import express from 'express';
import jwt from 'jsonwebtoken';
import {
  authenticatePasien,
  authenticateDokter,
  authenticateAdmin,
  registerPasien,
  updatePasienProfile,
} from '../repositories/authRepository.js';

const router = express.Router();

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-this-in-production';
const JWT_EXPIRY = '7d';

/**
 * POST /api/auth/login-pasien
 * Login sebagai pasien
 */
router.post('/login-pasien', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email dan password harus diisi',
      });
    }

    const authResult = await authenticatePasien(email, password);
    if (!authResult.success) {
      return res.status(401).json({
        success: false,
        message: authResult.error,
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      {
        userId: authResult.data.id,
        email: authResult.data.email,
        role: 'pasien',
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRY }
    );

    res.status(200).json({
      success: true,
      message: 'Login berhasil',
      token,
      user: authResult.data,
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan saat login',
      error: error.message,
    });
  }
});

/**
 * POST /api/auth/login-dokter
 * Login sebagai dokter
 */
router.post('/login-dokter', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email dan password harus diisi',
      });
    }

    const authResult = await authenticateDokter(email, password);
    if (!authResult.success) {
      return res.status(401).json({
        success: false,
        message: authResult.error,
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      {
        userId: authResult.data.id,
        email: authResult.data.email,
        role: 'dokter',
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRY }
    );

    res.status(200).json({
      success: true,
      message: 'Login berhasil',
      token,
      user: authResult.data,
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan saat login',
      error: error.message,
    });
  }
});

/**
 * POST /api/auth/login-admin
 * Login sebagai admin
 */
router.post('/login-admin', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email dan password harus diisi',
      });
    }

    const authResult = await authenticateAdmin(email, password);
    if (!authResult.success) {
      return res.status(401).json({
        success: false,
        message: authResult.error,
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      {
        userId: authResult.data.id,
        email: authResult.data.email,
        role: 'admin',
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRY }
    );

    res.status(200).json({
      success: true,
      message: 'Login berhasil',
      token,
      user: authResult.data,
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan saat login',
      error: error.message,
    });
  }
});

/**
 * POST /api/auth/register-pasien
 * Register akun pasien baru
 */
router.post('/register-pasien', async (req, res) => {
  try {
    const authResult = await registerPasien(req.body || {});
    if (!authResult.success) {
      const statusCode = authResult.error === 'Email sudah terdaftar' ? 409 : 400;
      return res.status(statusCode).json({
        success: false,
        message: authResult.error,
      });
    }

    return res.status(201).json({
      success: true,
      message: 'Registrasi pasien berhasil',
      user: authResult.data,
    });
  } catch (error) {
    console.error('Register error:', error);
    return res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan saat registrasi',
      error: error.message,
    });
  }
});

/**
 * GET /api/auth/verify
 * Verify JWT token
 */
router.get('/verify', (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token tidak ditemukan',
      });
    }

    const decoded = jwt.verify(token, JWT_SECRET);
    res.status(200).json({
      success: true,
      message: 'Token valid',
      user: decoded,
    });
  } catch (error) {
    res.status(401).json({
      success: false,
      message: 'Token tidak valid atau sudah kadaluarsa',
      error: error.message,
    });
  }
});

/**
 * PUT /api/auth/pasien/profile
 * Update profil pasien (nama, email, telepon, alamat, gender, foto base64)
 */
router.put('/pasien/profile', async (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token tidak ditemukan',
      });
    }

    let decoded;
    try {
      decoded = jwt.verify(token, JWT_SECRET);
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Token tidak valid atau sudah kadaluarsa',
        error: error.message,
      });
    }

    if (decoded?.role !== 'pasien') {
      return res.status(403).json({
        success: false,
        message: 'Endpoint ini khusus pasien',
      });
    }

    const updateResult = await updatePasienProfile(decoded.userId, req.body || {});
    if (!updateResult.success) {
      return res.status(updateResult.statusCode || 400).json({
        success: false,
        message: updateResult.error,
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Profil pasien berhasil diperbarui',
      user: updateResult.data,
    });
  } catch (error) {
    console.error('Update pasien profile route error:', error);
    return res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan saat memperbarui profil pasien',
      error: error.message,
    });
  }
});

export default router;
