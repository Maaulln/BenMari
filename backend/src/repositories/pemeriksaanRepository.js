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

export async function selesaikanPemeriksaan({
  appointmentId,
  dokterID,
  keluhan,
  diagnosis,
  tindakan,
  tekananDarah,
  beratBadan,
  catatanTambahan,
  obatList, // [{ namaObat, dosis, aturanPakai, jumlah, catatanResep }]
}) {
  let connection;
  try {
    connection = await getConnection();

    // 1. Validasi appointment
    const apptResult = await connection.execute(
      `SELECT APPOINTMENT_ID, PASIEN_ID, STATUS
       FROM APPOINTMENT
       WHERE APPOINTMENT_ID = :appointmentId`,
      { appointmentId }
    );
    const apptRows = normalizeRows(apptResult);

    if (apptRows.length === 0) {
      const err = new Error('Appointment tidak ditemukan');
      err.statusCode = 404;
      throw err;
    }

    if (apptRows[0].STATUS === 'selesai') {
      const err = new Error('Pemeriksaan sudah selesai sebelumnya');
      err.statusCode = 400;
      throw err;
    }

    // 2. Insert REKAM_MEDIS
    const rekamResult = await connection.execute(
      `INSERT INTO REKAM_MEDIS
         (REKAM_ID, APPOINTMENT_ID, DOKTER_ID, TGL_PERIKSA,
          KELUHAN, DIAGNOSIS, TINDAKAN,
          TEKANAN_DARAH, BERAT_BADAN, CATATAN_TAMBAHAN)
       VALUES
         (SEQ_REKAM_MEDIS.NEXTVAL, :appointmentId, :dokterID, SYSDATE,
          :keluhan, :diagnosis, :tindakan,
          :tekananDarah, :beratBadan, :catatanTambahan)
       RETURNING REKAM_ID INTO :rekamId`,
      {
        appointmentId,
        dokterID,
        keluhan: keluhan || null,
        diagnosis,
        tindakan: tindakan || null,
        tekananDarah: tekananDarah || null,
        beratBadan: beratBadan ? Number(beratBadan) : null,
        catatanTambahan: catatanTambahan || null,
        rekamId: { type: 'NUMBER', dir: 'out' },
      },
      { autoCommit: false }
    );

    const rekamId = rekamResult.outBinds.rekamId[0];

    // 3. Insert RESEP per obat (nama obat manual, tanpa FK OBAT_ID)
    if (obatList && obatList.length > 0) {
      for (const obat of obatList) {
        await connection.execute(
          `INSERT INTO RESEP
             (RESEP_ID, REKAM_ID, NAMA_OBAT_MANUAL, DOSIS, ATURAN_PAKAI, JUMLAH, CATATAN_RESEP)
           VALUES
             (SEQ_RESEP.NEXTVAL, :rekamId, :namaObat, :dosis, :aturanPakai, :jumlah, :catatanResep)`,
          {
            rekamId,
            namaObat: obat.namaObat || null,
            dosis: obat.dosis || null,
            aturanPakai: obat.aturanPakai || null,
            jumlah: obat.jumlah ? Number(obat.jumlah) : null,
            catatanResep: obat.catatanResep || null,
          },
          { autoCommit: false }
        );
      }
    }

    // 4. Update status APPOINTMENT jadi selesai
    await connection.execute(
      `UPDATE APPOINTMENT SET STATUS = 'selesai' WHERE APPOINTMENT_ID = :appointmentId`,
      { appointmentId },
      { autoCommit: false }
    );

    await connection.commit();
    return { rekamId, pasienId: apptRows[0].PASIEN_ID };
  } catch (err) {
    if (connection) await connection.rollback();
    throw err;
  } finally {
    if (connection) await connection.close();
  }
}

export async function getRiwayatPasien(pasienId) {
  let connection;
  try {
    connection = await getConnection();
    const result = await connection.execute(
      `SELECT rm.REKAM_ID, rm.TGL_PERIKSA, rm.DIAGNOSIS, rm.KELUHAN
       FROM REKAM_MEDIS rm
       JOIN APPOINTMENT a ON rm.APPOINTMENT_ID = a.APPOINTMENT_ID
       WHERE a.PASIEN_ID = :pasienId
       ORDER BY rm.TGL_PERIKSA DESC`,
      { pasienId }
    );
    return normalizeRows(result).map((row) => ({
      rekamId: row.REKAM_ID,
      tanggal: row.TGL_PERIKSA,
      diagnosis: row.DIAGNOSIS,
      keluhan: row.KELUHAN,
    }));
  } finally {
    if (connection) await connection.close();
  }
}