import { Router } from 'express';
import {
  selesaikanPemeriksaan,
  getRiwayatPasien,
} from '../repositories/pemeriksaanRepository.js';

const router = Router();

// GET /api/pemeriksaan/riwayat/:pasienId
router.get('/riwayat/:pasienId', async (req, res, next) => {
  try {
    const data = await getRiwayatPasien(Number(req.params.pasienId));
    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
});

// POST /api/pemeriksaan/selesai
router.post('/selesai', async (req, res, next) => {
  try {
    const {
      appointmentId,
      dokterID,
      keluhan,
      diagnosis,
      tindakan,
      tekananDarah,
      beratBadan,
      catatanTambahan,
      obatList,
    } = req.body;

    if (!appointmentId) {
      return res.status(400).json({ success: false, message: 'appointmentId wajib diisi' });
    }
    if (!dokterID) {
      return res.status(400).json({ success: false, message: 'dokterID wajib diisi' });
    }
    if (!diagnosis || String(diagnosis).trim() === '') {
      return res.status(400).json({ success: false, message: 'Diagnosis wajib diisi' });
    }

    const result = await selesaikanPemeriksaan({
      appointmentId: Number(appointmentId),
      dokterID: Number(dokterID),
      keluhan,
      diagnosis,
      tindakan,
      tekananDarah,
      beratBadan,
      catatanTambahan,
      obatList: obatList || [],
    });

    res.json({
      success: true,
      message: 'Pemeriksaan berhasil diselesaikan',
      data: result,
    });
  } catch (err) {
    next(err);
  }
});

export default router;