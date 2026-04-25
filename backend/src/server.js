import dotenv from 'dotenv';
import app from './app.js';
import { closePool } from './config/db.js';

dotenv.config();

const port = Number(process.env.PORT || 3000);

const server = app.listen(port, () => {
  console.log(`BenMari backend listening on http://localhost:${port}`);
});

async function shutdown(signal) {
  console.log(`${signal} received, shutting down...`);

  server.close(async () => {
    try {
      await closePool();
    } catch (error) {
      console.error('Error while closing Oracle pool:', error);
    }

    process.exit(0);
  });
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
