import { Router } from 'express';
import { createAppointment, listAppointmentsByPatient } from '../repositories/appointmentRepository.js';

const router = Router();

router.get('/', async (req, res, next) => {
  try {
    const appointments = await listAppointmentsByPatient(req.query.pasienId);

    res.json({
      success: true,
      message: 'Appointments fetched successfully',
      data: {
        items: appointments,
        total: appointments.length
      }
    });
  } catch (error) {
    next(error);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const appointment = await createAppointment(req.body);

    res.status(201).json({
      success: true,
      message: 'Appointment created successfully',
      data: appointment
    });
  } catch (error) {
    next(error);
  }
});

export default router;
