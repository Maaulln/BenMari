import { Router } from 'express';
import { listDoctors, listUserTables } from '../repositories/doctorRepository.js';

const router = Router();

router.get('/', async (req, res, next) => {
  try {
    const data = await listDoctors({
      search: req.query.search,
      limit: req.query.limit,
      offset: req.query.offset
    });

    res.json({
      success: true,
      message: 'Doctor list fetched successfully',
      data
    });
  } catch (error) {
    next(error);
  }
});

router.get('/meta/tables', async (req, res, next) => {
  try {
    const tables = await listUserTables();

    res.json({
      success: true,
      message: 'User tables fetched successfully',
      data: {
        tables
      }
    });
  } catch (error) {
    next(error);
  }
});

export default router;
