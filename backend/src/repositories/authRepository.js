import { getConnection } from '../config/db.js';
import bcrypt from 'bcryptjs';

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
    
    // Query pasien by email
    const result = await conn.execute(
      `SELECT PASIEN_ID, NAMA_LENGKAP, EMAIL_PASIEN, PASSWORD_PASIEN, 
              NO_TELEPON, ALAMAT, TANGGAL_LAHIR
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
  const normalizedGender = String(gender).trim().toUpperCase() === 'P' ? 'P' : 'L';
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

    const result = await conn.execute(
      `SELECT PASIEN_ID, NAMA_LENGKAP, EMAIL_PASIEN, NO_TELEPON, ALAMAT, TANGGAL_LAHIR
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


export async function updatePasienProfile(pasienId, payload = {}) {
  const { name, phone, address } = payload;

  if (!name || !phone) {
    return { success: false, error: 'Nama dan telepon wajib diisi' };
  }

  let conn;
  try {
    conn = await getConnection();

    await conn.execute(
      `UPDATE PASIEN SET
        NAMA_LENGKAP = :name,
        NO_TELEPON   = :phone,
        ALAMAT       = :address,
        UPDATED_AT   = SYSTIMESTAMP
       WHERE PASIEN_ID = :pasienId`,
      {
        name: String(name).trim(),
        phone: String(phone).trim(),
        address: address ? String(address).trim() : null,
        pasienId: Number(pasienId),
      },
      { autoCommit: true }
    );

    const result = await conn.execute(
      `SELECT PASIEN_ID, NAMA_LENGKAP, EMAIL_PASIEN, NO_TELEPON, ALAMAT
       FROM PASIEN WHERE PASIEN_ID = :pasienId`,
      { pasienId: Number(pasienId) }
    );

    const rows = normalizeRows(result);
    if (rows.length === 0) {
      return { success: false, error: 'Pasien tidak ditemukan' };
    }

    const p = rows[0];
    return {
      success: true,
      data: {
        id: String(p.PASIEN_ID),
        name: p.NAMA_LENGKAP,
        email: p.EMAIL_PASIEN,
        phone: p.NO_TELEPON,
        address: p.ALAMAT,
        role: 'pasien',
      },
    };
  } catch (error) {
    console.error('Update profile error:', error);
    return { success: false, error: error.message };
  } finally {
    if (conn) await conn.close();
  }
}