import { getConnection } from '../config/db.js';

function toPositiveInteger(value) {
  const parsed = Number.parseInt(value, 10);

  if (Number.isNaN(parsed) || parsed <= 0) {
    return null;
  }

  return parsed;
}

function isValidDate(value) {
  return /^\d{4}-\d{2}-\d{2}$/.test(String(value || ''));
}

function isValidTime(value) {
  return /^([01]\d|2[0-3]):[0-5]\d$/.test(String(value || ''));
}

function cleanText(value, max = 400) {
  if (value === undefined || value === null) {
    return null;
  }

  const text = String(value).trim();
  if (!text) {
    return null;
  }

  return text.slice(0, max);
}

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

    for (let index = 0; index < columns.length; index += 1) {
      mapped[columns[index]] = row[index];
    }

    return mapped;
  });
}

function badRequest(message) {
  const error = new Error(message);
  error.statusCode = 400;
  return error;
}

export async function createAppointment(payload = {}) {
  const pasienId = toPositiveInteger(payload.pasienId);
  const dokterId = toPositiveInteger(payload.dokterId);
  const tanggalAppointment = String(payload.tanggalAppointment || '').trim();
  const jamAppointment = String(payload.jamAppointment || '').trim();
  const keluhanAwal = cleanText(payload.keluhanAwal, 800);
  const catatan = cleanText(payload.catatan, 800);
  const status = cleanText(payload.status, 30) || 'MENUNGGU';

  if (!pasienId) {
    throw badRequest('pasienId wajib diisi dengan angka valid.');
  }

  if (!dokterId) {
    throw badRequest('dokterId wajib diisi dengan angka valid.');
  }

  if (!isValidDate(tanggalAppointment)) {
    throw badRequest('tanggalAppointment wajib format YYYY-MM-DD.');
  }

  if (!isValidTime(jamAppointment)) {
    throw badRequest('jamAppointment wajib format HH:mm (contoh 09:30).');
  }

  let connection;

  try {
    connection = await getConnection();

    const [pasienResult, dokterResult] = await Promise.all([
      connection.execute(
        `SELECT PASIEN_ID, NAMA_LENGKAP
         FROM PASIEN
         WHERE PASIEN_ID = :pasienId
           AND NVL(STATUS_AKTIF, 'Y') = 'Y'`,
        { pasienId }
      ),
      connection.execute(
        `SELECT DOKTER_ID, NAMA_DOKTER
         FROM DOKTER
         WHERE DOKTER_ID = :dokterId
           AND NVL(STATUS_AKTIF, 'Y') = 'Y'`,
        { dokterId }
      )
    ]);

    if (normalizeRows(pasienResult).length === 0) {
      const error = new Error('Pasien tidak ditemukan atau tidak aktif.');
      error.statusCode = 404;
      throw error;
    }

    if (normalizeRows(dokterResult).length === 0) {
      const error = new Error('Dokter tidak ditemukan atau tidak aktif.');
      error.statusCode = 404;
      throw error;
    }

    const duplicateResult = await connection.execute(
      `SELECT COUNT(1) AS TOTAL
       FROM APPOINTMENT
       WHERE DOKTER_ID = :dokterId
         AND TGL_APPOINTMENT = TO_DATE(:tanggalAppointment, 'YYYY-MM-DD')
         AND JAM_APPOINTMENT = :jamAppointment
         AND NVL(STATUS, 'MENUNGGU') <> 'BATAL'`,
      { dokterId, tanggalAppointment, jamAppointment }
    );

    const totalDuplicate = Number(normalizeRows(duplicateResult)?.[0]?.TOTAL || 0);
    if (totalDuplicate > 0) {
      const error = new Error('Jadwal dokter di jam tersebut sudah terisi.');
      error.statusCode = 409;
      throw error;
    }

    const serialResult = await connection.execute(
      `SELECT NVL(MAX(NOMOR_ANTRIAN), 0) + 1 AS NEXT_QUEUE
       FROM APPOINTMENT
       WHERE DOKTER_ID = :dokterId
         AND TGL_APPOINTMENT = TO_DATE(:tanggalAppointment, 'YYYY-MM-DD')`,
      { dokterId, tanggalAppointment }
    );

    const nextQueue = Number(normalizeRows(serialResult)?.[0]?.NEXT_QUEUE || 1);

    await connection.execute(
      `INSERT INTO APPOINTMENT (
         PASIEN_ID,
         DOKTER_ID,
         TGL_APPOINTMENT,
         JAM_APPOINTMENT,
         NOMOR_ANTRIAN,
         KELUHAN_AWAL,
         STATUS,
         CATATAN,
         CREATED_AT
       ) VALUES (
         :pasienId,
         :dokterId,
         TO_DATE(:tanggalAppointment, 'YYYY-MM-DD'),
         :jamAppointment,
         :nomorAntrian,
         :keluhanAwal,
         :status,
         :catatan,
         SYSTIMESTAMP
       )`,
      {
        pasienId,
        dokterId,
        tanggalAppointment,
        jamAppointment,
        nomorAntrian: nextQueue,
        keluhanAwal,
        status: status.toUpperCase(),
        catatan
      },
      { autoCommit: true }
    );

    const insertedResult = await connection.execute(
      `SELECT
         APPOINTMENT_ID,
         PASIEN_ID,
         DOKTER_ID,
         TO_CHAR(TGL_APPOINTMENT, 'YYYY-MM-DD') AS TANGGAL_APPOINTMENT,
         JAM_APPOINTMENT,
         NOMOR_ANTRIAN,
         KELUHAN_AWAL,
         STATUS,
         CATATAN,
         CREATED_AT
       FROM APPOINTMENT
       WHERE PASIEN_ID = :pasienId
         AND DOKTER_ID = :dokterId
         AND TGL_APPOINTMENT = TO_DATE(:tanggalAppointment, 'YYYY-MM-DD')
         AND JAM_APPOINTMENT = :jamAppointment
       ORDER BY APPOINTMENT_ID DESC
       FETCH FIRST 1 ROWS ONLY`,
      { pasienId, dokterId, tanggalAppointment, jamAppointment }
    );

    return normalizeRows(insertedResult)?.[0] || null;
  } finally {
    if (connection) {
      await connection.close();
    }
  }
}

export async function listAppointmentsByPatient(pasienId) {
  const safePasienId = toPositiveInteger(pasienId);
  if (!safePasienId) {
    throw badRequest('pasienId wajib diisi dengan angka valid.');
  }

  let connection;

  try {
    connection = await getConnection();

    const result = await connection.execute(
      `SELECT
         a.APPOINTMENT_ID,
         a.PASIEN_ID,
         a.DOKTER_ID,
         d.NAMA_DOKTER,
         d.SPESIALISASI,
         TO_CHAR(a.TGL_APPOINTMENT, 'YYYY-MM-DD') AS TANGGAL_APPOINTMENT,
         a.JAM_APPOINTMENT,
         a.NOMOR_ANTRIAN,
         a.KELUHAN_AWAL,
         a.STATUS,
         a.CATATAN,
         a.CREATED_AT
       FROM APPOINTMENT a
       JOIN DOKTER d ON d.DOKTER_ID = a.DOKTER_ID
       WHERE a.PASIEN_ID = :pasienId
       ORDER BY a.TGL_APPOINTMENT DESC, a.JAM_APPOINTMENT DESC`,
      { pasienId: safePasienId }
    );

    return normalizeRows(result);
  } finally {
    if (connection) {
      await connection.close();
    }
  }
}
