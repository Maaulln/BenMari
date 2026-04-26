import { Router } from 'express';
import { getConnection } from '../config/db.js';

const router = Router();

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
    for (let i = 0; i < columns.length; i += 1) {
      mapped[columns[i]] = row[i];
    }
    return mapped;
  });
}

function toSafeLimit(value, fallback = 10) {
  const parsed = Number.parseInt(value, 10);
  if (Number.isNaN(parsed)) {
    return fallback;
  }
  return Math.max(1, Math.min(parsed, 100));
}

router.get('/ping', async (req, res, next) => {
  let connection;
  try {
    connection = await getConnection();
    const result = await connection.execute('SELECT 1 AS result FROM dual');
    res.json({
      success: true,
      message: 'Oracle connection is healthy',
      data: result.rows?.[0] || null
    });
  } catch (error) {
    next(error);
  } finally {
    if (connection) await connection.close();
  }
});

router.get('/patients/recent', async (req, res, next) => {
  let connection;
  try {
    connection = await getConnection();
    const limit = toSafeLimit(req.query.limit, 10);

    const listResult = await connection.execute(
      `SELECT *
       FROM (
         SELECT
           PASIEN_ID, NAMA_LENGKAP, EMAIL_PASIEN, NO_TELEPON,
           ALAMAT, TANGGAL_LAHIR, JENIS_KELAMIN, GOLONGAN_DARAH,
           STATUS_AKTIF, CREATED_AT
         FROM PASIEN
         ORDER BY PASIEN_ID DESC
       )
       WHERE ROWNUM <= :limit`,
      { limit }
    );

    const countResult = await connection.execute(
      'SELECT COUNT(1) AS TOTAL FROM PASIEN'
    );

    const items = normalizeRows(listResult).map((row) => ({
      id: row.PASIEN_ID,
      name: row.NAMA_LENGKAP,
      email: row.EMAIL_PASIEN,
      phone: row.NO_TELEPON,
      address: row.ALAMAT,
      birthDate: row.TANGGAL_LAHIR,
      gender: row.JENIS_KELAMIN,
      bloodType: row.GOLONGAN_DARAH,
      isActive: row.STATUS_AKTIF,
      createdAt: row.CREATED_AT,
    }));

    const total = Number(normalizeRows(countResult)?.[0]?.TOTAL || 0);

    res.json({
      success: true,
      message: 'Recent patients fetched successfully',
      data: { items, total, limit }
    });
  } catch (error) {
    next(error);
  } finally {
    if (connection) await connection.close();
  }
});

router.get('/columns/:tableName', async (req, res, next) => {
  let connection;
  try {
    connection = await getConnection();
    const tableName = req.params.tableName.toUpperCase().replace(/[^A-Z0-9_]/g, '');
    const result = await connection.execute(
      `SELECT column_name, data_type, data_length, nullable
       FROM user_tab_columns
       WHERE table_name = :tableName
       ORDER BY column_id`,
      { tableName }
    );
    const columns = normalizeRows(result).map(row => ({
      column: row.COLUMN_NAME,
      type: row.DATA_TYPE,
      length: row.DATA_LENGTH,
      nullable: row.NULLABLE,
    }));
    res.json({ success: true, table: tableName, columns });
  } catch (error) {
    next(error);
  } finally {
    if (connection) await connection.close();
  }
});

// Migrasi tabel RESEP supaya support nama obat manual (tanpa FK ke OBAT)
// Aman dijalankan berkali-kali — semua error kolom sudah ada diabaikan
router.post('/setup/resep-manual', async (req, res, next) => {
  let connection;
  try {
    connection = await getConnection();
    const results = [];

    const alterations = [
      { sql: `ALTER TABLE RESEP MODIFY (OBAT_ID NULL)`, label: 'OBAT_ID nullable' },
      { sql: `ALTER TABLE RESEP MODIFY (DOSIS NULL)`, label: 'DOSIS nullable' },
      { sql: `ALTER TABLE RESEP MODIFY (ATURAN_PAKAI NULL)`, label: 'ATURAN_PAKAI nullable' },
      { sql: `ALTER TABLE RESEP MODIFY (JUMLAH NULL)`, label: 'JUMLAH nullable' },
      { sql: `ALTER TABLE RESEP ADD NAMA_OBAT_MANUAL VARCHAR2(200)`, label: 'kolom NAMA_OBAT_MANUAL' },
    ];

    for (const alt of alterations) {
      try {
        await connection.execute(alt.sql);
        results.push({ status: 'ok', label: alt.label });
      } catch (err) {
        // ORA-01430: kolom sudah ada, ORA-01451: sudah nullable — aman diabaikan
        results.push({ status: 'skip', label: alt.label, reason: err.message });
      }
    }

    await connection.commit();
    res.json({ success: true, results });
  } catch (error) {
    if (connection) await connection.rollback();
    next(error);
  } finally {
    if (connection) await connection.close();
  }
});

export default router;