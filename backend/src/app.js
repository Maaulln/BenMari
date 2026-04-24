import express from 'express';
import cors from 'cors';

import healthRoutes from './routes/healthRoutes.js';
import dbRoutes from './routes/dbRoutes.js';
import doctorRoutes from './routes/doctorRoutes.js';
import appointmentRoutes from './routes/appointmentRoutes.js';
import authRoutes from './routes/authRoutes.js';
import { errorHandler, notFound } from './middleware/errorHandler.js';

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
	res.json({
		success: true,
		message: 'Welcome to BenMari backend API',
		docs: '/api/routes'
	});
});

app.get('/api/routes', (req, res) => {
	res.json({
		success: true,
		message: 'Available API routes',
		data: [
			{ method: 'GET', path: '/' },
			{ method: 'GET', path: '/api/routes' },
			{ method: 'GET', path: '/api/health' },
			{ method: 'GET', path: '/api/db/ping' },
			{ method: 'GET', path: '/api/db/patients/recent' },
			{ method: 'POST', path: '/api/auth/login-pasien' },
			{ method: 'POST', path: '/api/auth/login-dokter' },
			{ method: 'POST', path: '/api/auth/login-admin' },
			{ method: 'POST', path: '/api/auth/register-pasien' },
			{ method: 'GET', path: '/api/auth/verify' },
			{ method: 'GET', path: '/api/doctors' },
			{ method: 'GET', path: '/api/doctors/meta/tables' },
			{ method: 'GET', path: '/api/appointments' },
			{ method: 'POST', path: '/api/appointments' }
		]
	});
});

app.use('/api/health', healthRoutes);
app.use('/api/db', dbRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/appointments', appointmentRoutes);

app.use(notFound);
app.use(errorHandler);

export default app;
