import { Router } from 'express';
import { getConnection } from '../config/db.js';

const router = Router();

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
    if (connection) {
      await connection.close();
    }
  }
});

export default router;
