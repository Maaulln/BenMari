import { getConnection } from '../config/db.js';

function normalizeRows(result = {}) {
  const rows = Array.isArray(result.rows) ? result.rows : [];
  if (rows.length === 0) return [];
  if (!Array.isArray(rows[0])) return rows;
  const columns = Array.isArray(result.metaData)
    ? result.metaData.map((item) => String(item?.name || '').toUpperCase())
    : [];
  return rows.map((row) => {
    const mapped = {};
    for (let i = 0; i < columns.length; i++) {
      mapped[columns[i]] = row[i];
    }
    return mapped;
  });
}

/** GET /api/admin/stats */
export async function getAdminStats() {
  const conn = await getConnection();
  try {
    const [dokterRes, pasienRes, appointmentRes, menanggRes] = await Promise.all([
      conn.execute(`SELECT COUNT(1) AS TOTAL FROM DOKTER`),
      conn.execute(`SELECT COUNT(1) AS TOTAL FROM PASIEN`),
      conn.execute(`SELECT COUNT(1) AS TOTAL FROM APPOINTMENT`),
      conn.execute(`SELECT COUNT(1) AS TOTAL FROM APPOINTMENT WHERE UPPER(STATUS) = 'MENUNGGU'`),
    ]);
    return {
      totalDokter: Number(normalizeRows(dokterRes)?.[0]?.TOTAL || 0),
      totalPasien: Number(normalizeRows(pasienRes)?.[0]?.TOTAL || 0),
      totalAppointment: Number(normalizeRows(appointmentRes)?.[0]?.TOTAL || 0),
      appointmentMenunggu: Number(normalizeRows(menanggRes)?.[0]?.TOTAL || 0),
    };
  } finally {
    await conn.close();
  }
}

/** GET /api/admin/patients */
export async function getAllPasien({ search, limit, offset }) {
  const safeLimit = Math.max(1, Math.min(Number.parseInt(limit, 10) || 20, 100));
  const safeOffset = Math.max(0, Number.parseInt(offset, 10) || 0);
  const conn = await getConnection();
  try {
    const binds = { offset: safeOffset, limit: safeLimit };
    let where = '';
    if (search) {
      where = `WHERE LOWER(NAMA_LENGKAP) LIKE :search OR LOWER(EMAIL_PASIEN) LIKE :search`;
      binds.search = `%${String(search).toLowerCase()}%`;
    }
    const result = await conn.execute(
      `SELECT PASIEN_ID, NAMA_LENGKAP, EMAIL_PASIEN, NO_TELEPON, ALAMAT,
              TO_CHAR(TANGGAL_LAHIR, 'YYYY-MM-DD') AS TANGGAL_LAHIR,
              JENIS_KELAMIN, STATUS_AKTIF,
              TO_CHAR(CREATED_AT, 'YYYY-MM-DD') AS CREATED_AT
       FROM PASIEN
       ${where}
       ORDER BY PASIEN_ID
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      binds
    );
    const countRes = await conn.execute(
      `SELECT COUNT(1) AS TOTAL FROM PASIEN ${where}`,
      search ? { search: binds.search } : {}
    );
    return {
      items: normalizeRows(result),
      total: Number(normalizeRows(countRes)?.[0]?.TOTAL || 0),
    };
  } finally {
    await conn.close();
  }
}

/** GET /api/admin/appointments */
export async function getAllAppointments({ search, status, limit, offset }) {
  const safeLimit = Math.max(1, Math.min(Number.parseInt(limit, 10) || 20, 100));
  const safeOffset = Math.max(0, Number.parseInt(offset, 10) || 0);
  const conn = await getConnection();
  try {
    const binds = { offset: safeOffset, limit: safeLimit };
    const clauses = [];
    if (search) {
      clauses.push(`(LOWER(p.NAMA_LENGKAP) LIKE :search OR LOWER(d.NAMA_DOKTER) LIKE :search)`);
      binds.search = `%${String(search).toLowerCase()}%`;
    }
    if (status) {
      clauses.push(`UPPER(a.STATUS) = :status`);
      binds.status = String(status).toUpperCase();
    }
    const where = clauses.length > 0 ? `WHERE ${clauses.join(' AND ')}` : '';
    const result = await conn.execute(
      `SELECT a.APPOINTMENT_ID, a.PASIEN_ID, a.DOKTER_ID,
              p.NAMA_LENGKAP AS NAMA_PASIEN,
              d.NAMA_DOKTER, d.SPESIALISASI,
              TO_CHAR(a.TGL_APPOINTMENT, 'YYYY-MM-DD') AS TGL_APPOINTMENT,
              a.JAM_APPOINTMENT, a.NOMOR_ANTRIAN,
              a.KELUHAN_AWAL, a.STATUS, a.CATATAN,
              TO_CHAR(a.CREATED_AT, 'YYYY-MM-DD') AS CREATED_AT
       FROM APPOINTMENT a
       JOIN PASIEN p ON p.PASIEN_ID = a.PASIEN_ID
       JOIN DOKTER d ON d.DOKTER_ID = a.DOKTER_ID
       ${where}
       ORDER BY a.TGL_APPOINTMENT DESC, a.JAM_APPOINTMENT DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      binds
    );
    const countRes = await conn.execute(
      `SELECT COUNT(1) AS TOTAL
       FROM APPOINTMENT a
       JOIN PASIEN p ON p.PASIEN_ID = a.PASIEN_ID
       JOIN DOKTER d ON d.DOKTER_ID = a.DOKTER_ID
       ${where}`,
      Object.fromEntries(Object.entries(binds).filter(([k]) => k !== 'offset' && k !== 'limit'))
    );
    return {
      items: normalizeRows(result),
      total: Number(normalizeRows(countRes)?.[0]?.TOTAL || 0),
    };
  } finally {
    await conn.close();
  }
}

/** PUT /api/admin/doctors/:id/status */
export async function toggleDokterStatus(dokterId, statusAktif) {
  const conn = await getConnection();
  try {
    await conn.execute(
      `UPDATE DOKTER SET STATUS_AKTIF = :status WHERE DOKTER_ID = :id`,
      { status: statusAktif, id: Number(dokterId) },
      { autoCommit: true }
    );
    const result = await conn.execute(
      `SELECT DOKTER_ID, NAMA_DOKTER, SPESIALISASI, STATUS_AKTIF FROM DOKTER WHERE DOKTER_ID = :id`,
      { id: Number(dokterId) }
    );
    return normalizeRows(result)?.[0] || null;
  } finally {
    await conn.close();
  }
}