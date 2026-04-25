import { getConnection } from '../config/db.js';

const PASIEN_PHOTO_COLUMN = 'FOTO_PROFIL_BASE64';

function normalizeRows(result = {}) {
  const rows = Array.isArray(result.rows) ? result.rows : [];
  if (rows.length === 0) {
    return [];
  }

  if (!Array.isArray(rows[0])) {
    return rows;
  }

  const columns = Array.isArray(result.metaData)
    ? result.metaData.map((item) => String(item?.name || '').toUpperCase())
    : [];

  return rows.map((row) => {
    const mapped = {};
    for (let i = 0; i < columns.length; i++) {
      if (row[i] !== null) {
        mapped[columns[i]] = row[i];
      }
    }
    return mapped;
  });
}

function normalizeGenderForDb(value) {
  const raw = String(value || '').trim().toUpperCase();
  if (raw === 'L' || raw === 'LAKI-LAKI') {
    return 'L';
  }
  if (raw === 'P' || raw === 'PEREMPUAN') {
    return 'P';
  }
  return null;
}

function toGenderLabel(value) {
  const raw = String(value || '').trim().toUpperCase();
  if (raw === 'L') {
    return 'Laki-laki';
  }
  if (raw === 'P') {
    return 'Perempuan';
  }
  return '-';
}

function sanitizePhotoValue(photoBase64) {
  if (photoBase64 === undefined || photoBase64 === null) {
    return undefined;
  }

  const raw = String(photoBase64).trim();
  if (!raw) {
    return '';
  }

  const withoutPrefix = raw.includes(',') ? raw.split(',').pop() : raw;
  const compact = String(withoutPrefix || '').replace(/\s+/g, '');
  if (!compact) {
    return '';
  }

  if (!/^[A-Za-z0-9+/=]+$/.test(compact)) {
    throw new Error('Format fotoBase64 tidak valid');
  }

  if (compact.length > 2_000_000) {
    throw new Error('Ukuran foto terlalu besar (maksimum sekitar 1.5MB)');
  }

  return compact;
}

async function hasColumn(conn, tableName, columnName) {
  const result = await conn.execute(
    `SELECT COUNT(1) AS TOTAL
     FROM USER_TAB_COLS
     WHERE TABLE_NAME = :tableName
       AND COLUMN_NAME = :columnName`,
    {
      tableName: String(tableName || '').toUpperCase(),
      columnName: String(columnName || '').toUpperCase(),
    }
  );

  const rows = normalizeRows(result);
  return Number(rows?.[0]?.TOTAL || 0) > 0;
}

async function ensurePasienPhotoColumn(conn) {
  const exists = await hasColumn(conn, 'PASIEN', PASIEN_PHOTO_COLUMN);
  if (exists) {
    return;
  }

  try {
    await conn.execute(
      `ALTER TABLE PASIEN ADD ${PASIEN_PHOTO_COLUMN} CLOB`
    );
  } catch (error) {
    if (error?.errorNum !== 1430) {
      throw error;
    }
  }
}

/**
 * Authenticate a patient (PASIEN)
 * @param {string} email - Patient email
 * @param {string} password - Patient password
 * @returns {Promise<{success: boolean, data?: object, error?: string}>}
 */
export async function authenticatePasien(email, password) {
  if (!email || !password) {
    return { success: false, error: 'Email dan password harus diisi' };
  }

  try {
    const conn = await getConnection();
    const hasPhotoColumn = await hasColumn(conn, 'PASIEN', PASIEN_PHOTO_COLUMN);
    const photoColumnSql = hasPhotoColumn ? `, ${PASIEN_PHOTO_COLUMN}` : '';
    
    // Query pasien by email
    const result = await conn.execute(
      `SELECT PASIEN_ID, NAMA_LENGKAP, EMAIL_PASIEN, PASSWORD_PASIEN, 
              NO_TELEPON, ALAMAT, TANGGAL_LAHIR, JENIS_KELAMIN
              ${photoColumnSql}
       FROM PASIEN 
       WHERE EMAIL_PASIEN = :email`,
      { email: email.toLowerCase() }
    );

    conn.close();

    const rows = normalizeRows(result);
    if (rows.length === 0) {
      return { success: false, error: 'Email tidak ditemukan' };
    }

    const pasien = rows[0];
    
    // Simple password comparison
    if (pasien.PASSWORD_PASIEN !== password) {
      return { success: false, error: 'Password salah' };
    }

    // Return user data without password
    const userData = {
      id: String(pasien.PASIEN_ID),
      name: pasien.NAMA_LENGKAP,
      email: pasien.EMAIL_PASIEN,
      phone: pasien.NO_TELEPON,
      address: pasien.ALAMAT,
      birthDate: pasien.TANGGAL_LAHIR,
      gender: toGenderLabel(pasien.JENIS_KELAMIN),
      photoBase64: hasPhotoColumn ? (pasien[PASIEN_PHOTO_COLUMN] || null) : null,
      role: 'pasien'
    };

    return { success: true, data: userData };
  } catch (error) {
    console.error('Auth error (pasien):', error);
    return { success: false, error: error.message };
  }
}

/**
 * Authenticate a doctor (DOKTER)
 * @param {string} email - Doctor email
 * @param {string} password - Doctor password
 * @returns {Promise<{success: boolean, data?: object, error?: string}>}
 */
export async function authenticateDokter(email, password) {
  if (!email || !password) {
    return { success: false, error: 'Email dan password harus diisi' };
  }

  try {
    const conn = await getConnection();
    
    // Query dokter by email
    const result = await conn.execute(
      `SELECT DOKTER_ID, NAMA_DOKTER, EMAIL_DOKTER, PASSWORD_DOKTER,
              NO_TELEPON, SPESIALISASI, JADWAL_PRAKTIK, STATUS_AKTIF
       FROM DOKTER 
       WHERE EMAIL_DOKTER = :email`,
      { email: email.toLowerCase() }
    );

    conn.close();

    const rows = normalizeRows(result);
    if (rows.length === 0) {
      return { success: false, error: 'Email tidak ditemukan' };
    }

    const dokter = rows[0];
    
    // Simple password comparison
    if (dokter.PASSWORD_DOKTER !== password) {
      return { success: false, error: 'Password salah' };
    }

    // Check if doctor is active
    if (dokter.STATUS_AKTIF != 1 && dokter.STATUS_AKTIF !== 'Y') {
      return { success: false, error: 'Akun dokter tidak aktif' };
    }

    // Return user data without password
    const userData = {
      id: String(dokter.DOKTER_ID),
      name: dokter.NAMA_DOKTER,
      email: dokter.EMAIL_DOKTER,
      phone: dokter.NO_TELEPON,
      specialization: dokter.SPESIALISASI,
      schedule: dokter.JADWAL_PRAKTIK,
      isActive: dokter.STATUS_AKTIF,
      role: 'dokter'
    };

    return { success: true, data: userData };
  } catch (error) {
    console.error('Auth error (dokter):', error);
    return { success: false, error: error.message };
  }
}

/**
 * Authenticate an admin
 * @param {string} email - Admin email
 * @param {string} password - Admin password
 * @returns {Promise<{success: boolean, data?: object, error?: string}>}
 */
export async function authenticateAdmin(email, password) {
  if (!email || !password) {
    return { success: false, error: 'Email dan password harus diisi' };
  }

  try {
    const conn = await getConnection();
    
    // Query admin by email
    const result = await conn.execute(
      `SELECT ID_ADMIN, NAMA_ADMIN, EMAIL_ADMIN, PASSWORD_ADMIN, NO_TELP_ADMIN
       FROM ADMIN 
       WHERE EMAIL_ADMIN = :email`,
      { email: email.toLowerCase() }
    );

    conn.close();

    const rows = normalizeRows(result);
    if (rows.length === 0) {
      return { success: false, error: 'Email tidak ditemukan' };
    }

    const admin = rows[0];
    
    // Simple password comparison
    if (admin.PASSWORD_ADMIN !== password) {
      return { success: false, error: 'Password salah' };
    }

    // Return user data without password
    const userData = {
      id: String(admin.ID_ADMIN),
      name: admin.NAMA_ADMIN,
      email: admin.EMAIL_ADMIN,
      phone: admin.NO_TELP_ADMIN,
      role: 'admin'
    };

    return { success: true, data: userData };
  } catch (error) {
    console.error('Auth error (admin):', error);
    return { success: false, error: error.message };
  }
}

/**
 * Register a new patient account (PASIEN)
 * @param {object} payload - registration data
 * @returns {Promise<{success: boolean, data?: object, error?: string}>}
 */
export async function registerPasien(payload = {}) {
  const {
    name,
    email,
    password,
    phone,
    address,
    birthDate,
    gender,
    nik,
    bloodType,
  } = payload;

  if (!name || !email || !password || !phone || !address || !birthDate || !gender) {
    return {
      success: false,
      error: 'Nama, email, password, telepon, alamat, tanggal lahir, dan jenis kelamin wajib diisi',
    };
  }

  const normalizedEmail = String(email).trim().toLowerCase();
  const normalizedGender = normalizeGenderForDb(gender) || 'L';
  const normalizedNik = String(nik || `${Date.now()}`)
    .replace(/\D/g, '')
    .padEnd(16, '0')
    .slice(0, 16);
  const normalizedBloodType = String(bloodType || '-').trim().toUpperCase();

  let conn;
  try {
    conn = await getConnection();

    const checkResult = await conn.execute(
      `SELECT PASIEN_ID
       FROM PASIEN
       WHERE LOWER(EMAIL_PASIEN) = :email`,
      { email: normalizedEmail }
    );

    const checkRows = normalizeRows(checkResult);
    if (checkRows.length > 0) {
      return { success: false, error: 'Email sudah terdaftar' };
    }

    await conn.execute(
      `INSERT INTO PASIEN (
        NIK,
        NAMA_LENGKAP,
        TANGGAL_LAHIR,
        JENIS_KELAMIN,
        ALAMAT,
        NO_TELEPON,
        EMAIL,
        GOLONGAN_DARAH,
        STATUS_AKTIF,
        CREATED_AT,
        EMAIL_PASIEN,
        PASSWORD_PASIEN
      ) VALUES (
        :nik,
        :name,
        TO_DATE(:birthDate, 'YYYY-MM-DD'),
        :gender,
        :address,
        :phone,
        :email,
        :bloodType,
        'Y',
        SYSTIMESTAMP,
        :email,
        :password
      )`,
      {
        nik: normalizedNik,
        name: String(name).trim(),
        birthDate: String(birthDate).trim(),
        gender: normalizedGender,
        address: String(address).trim(),
        phone: String(phone).trim(),
        email: normalizedEmail,
        bloodType: normalizedBloodType,
        password,
      }
    );

    await conn.commit();

    const hasPhotoColumn = await hasColumn(conn, 'PASIEN', PASIEN_PHOTO_COLUMN);
    const photoColumnSql = hasPhotoColumn ? `, ${PASIEN_PHOTO_COLUMN}` : '';

    const result = await conn.execute(
      `SELECT PASIEN_ID, NAMA_LENGKAP, EMAIL_PASIEN, NO_TELEPON, ALAMAT, TANGGAL_LAHIR, JENIS_KELAMIN
              ${photoColumnSql}
       FROM PASIEN
       WHERE LOWER(EMAIL_PASIEN) = :email`,
      { email: normalizedEmail }
    );

    const rows = normalizeRows(result);
    if (rows.length === 0) {
      return { success: false, error: 'Gagal membuat akun pasien' };
    }

    const pasien = rows[0];
    return {
      success: true,
      data: {
        id: String(pasien.PASIEN_ID),
        name: pasien.NAMA_LENGKAP,
        email: pasien.EMAIL_PASIEN,
        phone: pasien.NO_TELEPON,
        address: pasien.ALAMAT,
        birthDate: pasien.TANGGAL_LAHIR,
        gender: toGenderLabel(pasien.JENIS_KELAMIN),
        photoBase64: hasPhotoColumn ? (pasien[PASIEN_PHOTO_COLUMN] || null) : null,
        role: 'pasien',
      },
    };
  } catch (error) {
    console.error('Register error (pasien):', error);
    if (error?.errorNum === 1) {
      return { success: false, error: 'Email sudah terdaftar' };
    }
    return { success: false, error: error.message };
  } finally {
    if (conn) {
      try {
        await conn.close();
      } catch (_) {
        // ignore close error
      }
    }
  }
}

/**
 * Update patient profile data and profile photo.
 * @param {string|number} pasienId - patient id from JWT token
 * @param {object} payload - profile payload
 * @returns {Promise<{success: boolean, data?: object, error?: string, statusCode?: number}>}
 */
export async function updatePasienProfile(pasienId, payload = {}) {
  const safePasienId = Number(pasienId);
  if (!Number.isFinite(safePasienId) || safePasienId <= 0) {
    return { success: false, error: 'ID pasien tidak valid', statusCode: 400 };
  }

  let conn;
  try {
    conn = await getConnection();
    await ensurePasienPhotoColumn(conn);

    const name = payload.name !== undefined ? String(payload.name || '').trim() : undefined;
    const email = payload.email !== undefined ? String(payload.email || '').trim().toLowerCase() : undefined;
    const phone = payload.phone !== undefined ? String(payload.phone || '').trim() : undefined;
    const address = payload.address !== undefined ? String(payload.address || '').trim() : undefined;
    const gender = payload.gender !== undefined ? normalizeGenderForDb(payload.gender) : undefined;
    const photoBase64 = sanitizePhotoValue(payload.photoBase64);

    if (name !== undefined && !name) {
      return { success: false, error: 'Nama tidak boleh kosong', statusCode: 400 };
    }

    if (email !== undefined && !email) {
      return { success: false, error: 'Email tidak boleh kosong', statusCode: 400 };
    }

    if (gender !== undefined && gender === null) {
      return { success: false, error: 'Jenis kelamin harus L/P atau Laki-laki/Perempuan', statusCode: 400 };
    }

    const updateClauses = [];
    const binds = { pasienId: safePasienId };

    if (name !== undefined) {
      updateClauses.push('NAMA_LENGKAP = :name');
      binds.name = name;
    }

    if (email !== undefined) {
      const emailCheck = await conn.execute(
        `SELECT PASIEN_ID
         FROM PASIEN
         WHERE LOWER(EMAIL_PASIEN) = :email
           AND PASIEN_ID <> :pasienId`,
        {
          email,
          pasienId: safePasienId,
        }
      );
      const emailRows = normalizeRows(emailCheck);
      if (emailRows.length > 0) {
        return { success: false, error: 'Email sudah digunakan pasien lain', statusCode: 409 };
      }

      updateClauses.push('EMAIL_PASIEN = :email');
      updateClauses.push('EMAIL = :email');
      binds.email = email;
    }

    if (phone !== undefined) {
      updateClauses.push('NO_TELEPON = :phone');
      binds.phone = phone;
    }

    if (address !== undefined) {
      updateClauses.push('ALAMAT = :address');
      binds.address = address;
    }

    if (gender !== undefined) {
      updateClauses.push('JENIS_KELAMIN = :gender');
      binds.gender = gender;
    }

    if (photoBase64 !== undefined) {
      updateClauses.push(`${PASIEN_PHOTO_COLUMN} = :photoBase64`);
      binds.photoBase64 = photoBase64 || null;
    }

    if (updateClauses.length === 0) {
      return { success: false, error: 'Tidak ada data yang diubah', statusCode: 400 };
    }

    const updateResult = await conn.execute(
      `UPDATE PASIEN
       SET ${updateClauses.join(', ')}
       WHERE PASIEN_ID = :pasienId`,
      binds
    );

    if (Number(updateResult?.rowsAffected || 0) === 0) {
      return { success: false, error: 'Pasien tidak ditemukan', statusCode: 404 };
    }

    await conn.commit();

    const profileResult = await conn.execute(
      `SELECT PASIEN_ID, NAMA_LENGKAP, EMAIL_PASIEN, NO_TELEPON, ALAMAT, TANGGAL_LAHIR,
              JENIS_KELAMIN, ${PASIEN_PHOTO_COLUMN}
       FROM PASIEN
       WHERE PASIEN_ID = :pasienId`,
      { pasienId: safePasienId }
    );

    const profileRows = normalizeRows(profileResult);
    if (profileRows.length === 0) {
      return { success: false, error: 'Pasien tidak ditemukan setelah update', statusCode: 404 };
    }

    const pasien = profileRows[0];
    return {
      success: true,
      data: {
        id: String(pasien.PASIEN_ID),
        name: pasien.NAMA_LENGKAP,
        email: pasien.EMAIL_PASIEN,
        phone: pasien.NO_TELEPON,
        address: pasien.ALAMAT,
        birthDate: pasien.TANGGAL_LAHIR,
        gender: toGenderLabel(pasien.JENIS_KELAMIN),
        photoBase64: pasien[PASIEN_PHOTO_COLUMN] || null,
        role: 'pasien',
      },
    };
  } catch (error) {
    console.error('Update profile error (pasien):', error);
    return { success: false, error: error.message, statusCode: 500 };
  } finally {
    if (conn) {
      try {
        await conn.close();
      } catch (_) {
        // ignore close error
      }
    }
  }
}
