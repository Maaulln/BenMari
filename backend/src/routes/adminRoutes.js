import { Router } from 'express';
import {
  getAdminStats,
  getAllPasien,
  getAllAppointments,
  toggleDokterStatus,
} from '../repositories/adminRepository.js';
import { listDoctors } from '../repositories/doctorRepository.js';

const router = Router();

// GET /api/admin/stats
router.get('/stats', async (req, res, next) => {
  try {
    const data = await getAdminStats();
    res.json({ success: true, data });
  } catch (e) { next(e); }
});

// GET /api/admin/doctors
router.get('/doctors', async (req, res, next) => {
  try {
    const data = await listDoctors({
      search: req.query.search,
      limit: req.query.limit,
      offset: req.query.offset,
    });
    res.json({ success: true, data });
  } catch (e) { next(e); }
});

// PUT /api/admin/doctors/:id/status
router.put('/doctors/:id/status', async (req, res, next) => {
  try {
    const { statusAktif } = req.body;
    if (statusAktif === undefined) {
      return res.status(400).json({ success: false, message: 'statusAktif wajib diisi' });
    }
    const data = await toggleDokterStatus(req.params.id, statusAktif);
    res.json({ success: true, data });
  } catch (e) { next(e); }
});

// GET /api/admin/patients
router.get('/patients', async (req, res, next) => {
  try {
    const data = await getAllPasien({
      search: req.query.search,
      limit: req.query.limit,
      offset: req.query.offset,
    });
    res.json({ success: true, data });
  } catch (e) { next(e); }
});

// GET /api/admin/appointments
router.get('/appointments', async (req, res, next) => {
  try {
    const data = await getAllAppointments({
      search: req.query.search,
      status: req.query.status,
      limit: req.query.limit,
      offset: req.query.offset,
    });
    res.json({ success: true, data });
  } catch (e) { next(e); }
});

export default router;