import oracledb from 'oracledb';

let poolPromise;

async function createPool() {
  if (!process.env.ORACLE_USER || !process.env.ORACLE_PASSWORD || !process.env.ORACLE_CONNECTION_STRING) {
    throw new Error('Oracle environment variables are not complete. Check ORACLE_USER, ORACLE_PASSWORD, and ORACLE_CONNECTION_STRING.');
  }

  return oracledb.createPool({
    user: process.env.ORACLE_USER,
    password: process.env.ORACLE_PASSWORD,
    connectionString: process.env.ORACLE_CONNECTION_STRING,
    poolAlias: process.env.ORACLE_POOL_ALIAS || 'BENMARI_POOL'
  });
}

export async function getPool() {
  if (!poolPromise) {
    poolPromise = createPool();
  }

  return poolPromise;
}

export async function getConnection() {
  const pool = await getPool();
  return pool.getConnection();
}

export async function closePool() {
  if (!poolPromise) {
    return;
  }

  const pool = await poolPromise;
  await pool.close(10);
  poolPromise = undefined;
}
