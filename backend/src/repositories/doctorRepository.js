import { getConnection } from '../config/db.js';

const DEFAULT_CANDIDATE_TABLES = [
  'DOKTER',
  'DOKTERS',
  'DOCTOR',
  'DOCTORS',
  'TB_DOKTER',
  'M_DOKTER'
];

const COLUMN_ALIASES = {
  id: ['ID_DOKTER', 'DOKTER_ID', 'DOCTOR_ID', 'ID', 'KODE_DOKTER'],
  name: ['NAMA_DOKTER', 'NAMA', 'DOCTOR_NAME', 'NM_DOKTER', 'NAME'],
  specialization: ['SPESIALISASI', 'SPECIALIZATION', 'SPESIALIS', 'BIDANG'],
  clinic: ['POLI', 'KLINIK', 'DEPARTEMEN', 'DEPARTMENT'],
  phone: ['NO_TELP', 'NO_TELEPON', 'TELEPON', 'PHONE', 'NO_HP'],
  isActive: ['IS_ACTIVE', 'STATUS_AKTIF', 'AKTIF']
};

function toSafeOracleIdentifier(value) {
  if (!value) {
    return null;
  }

  const normalized = String(value).trim().toUpperCase();
  if (!/^[A-Z][A-Z0-9_$#]*$/.test(normalized)) {
    return null;
  }

  return normalized;
}

function normalizeCandidateTables() {
  const envCandidates = process.env.ORACLE_DOCTOR_TABLE_CANDIDATES;

  if (!envCandidates) {
    return DEFAULT_CANDIDATE_TABLES;
  }

  const cleaned = envCandidates
    .split(',')
    .map((value) => toSafeOracleIdentifier(value))
    .filter(Boolean);

  return cleaned.length > 0 ? cleaned : DEFAULT_CANDIDATE_TABLES;
}

function getAliasValue(row = {}, aliases = []) {
  for (const key of aliases) {
    if (row[key] !== undefined && row[key] !== null) {
      return row[key];
    }
  }

  return null;
}

function toDoctorDto(row) {
  const idValue = getAliasValue(row, COLUMN_ALIASES.id);
  const nameValue = getAliasValue(row, COLUMN_ALIASES.name);

  return {
    id: idValue !== null ? String(idValue) : null,
    name: nameValue !== null ? String(nameValue) : null,
    specialization: getAliasValue(row, COLUMN_ALIASES.specialization),
    clinic: getAliasValue(row, COLUMN_ALIASES.clinic),
    phone: getAliasValue(row, COLUMN_ALIASES.phone),
    isActive: getAliasValue(row, COLUMN_ALIASES.isActive),
    raw: row
  };
}

function normalizeNumber(value, fallback) {
  const parsed = Number.parseInt(value, 10);

  if (Number.isNaN(parsed)) {
    return fallback;
  }

  return parsed;
}

async function resolveDoctorTable(connection) {
  const preferredTable = toSafeOracleIdentifier(process.env.ORACLE_DOCTOR_TABLE);
  if (preferredTable) {
    return preferredTable;
  }

  const candidates = normalizeCandidateTables();

  const result = await connection.execute('SELECT table_name FROM user_tables');
  const rows = normalizeRows(result);
  const tableNames = rows
    .map((row) => String(row.TABLE_NAME || '').toUpperCase())
    .filter(Boolean);

  const existing = new Set(tableNames);

  const exactCandidate = candidates.find((table) => existing.has(table));
  if (exactCandidate) {
    return exactCandidate;
  }

  const fuzzyCandidate = tableNames.find((table) => table.includes('DOKTER') || table.includes('DOCTOR'));
  if (fuzzyCandidate) {
    return fuzzyCandidate;
  }

  return null;
}

function resolveNameColumn(columns = []) {
  const lookup = new Set(columns.map((value) => value.toUpperCase()));

  for (const alias of COLUMN_ALIASES.name) {
    if (lookup.has(alias)) {
      return alias;
    }
  }

  return null;
}

function normalizeRows(result = {}) {
  const rows = Array.isArray(result.rows) ? result.rows : [];
  if (rows.length === 0) {
    return [];
  }

  if (!Array.isArray(rows[0])) {
    return rows;
  }

  const columns = Array.isArray(result.metaData)
    ? result.metaData.map((item) => String(item?.name || '').toUpperCase())
    : [];

  return rows.map((row) => {
    const mapped = {};

    for (let index = 0; index < columns.length; index += 1) {
      mapped[columns[index]] = row[index];
    }

    return mapped;
  });
}

export async function listDoctors({ search, limit, offset }) {
  const safeLimit = Math.max(1, Math.min(normalizeNumber(limit, 20), 100));
  const safeOffset = Math.max(0, normalizeNumber(offset, 0));

  let connection;

  try {
    connection = await getConnection();

    const tableName = await resolveDoctorTable(connection);
    if (!tableName) {
      const error = new Error('Tabel dokter tidak ditemukan. Set ORACLE_DOCTOR_TABLE di .env sesuai nama tabel dokter kamu.');
      error.statusCode = 404;
      throw error;
    }

    const columnResult = await connection.execute(
      `SELECT column_name FROM user_tab_columns WHERE table_name = '${tableName}' ORDER BY column_id`
    );
    const columns = normalizeRows(columnResult).map((row) => String(row.COLUMN_NAME).toUpperCase());

    const nameColumn = resolveNameColumn(columns);

    const whereClauses = [];
    const binds = { offset: safeOffset, limit: safeLimit };

    if (search && nameColumn) {
      whereClauses.push(`LOWER(${nameColumn}) LIKE :search`);
      binds.search = `%${String(search).toLowerCase()}%`;
    }

    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

    const listQuery = `
      SELECT *
      FROM ${tableName}
      ${whereSql}
      ORDER BY 1
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY
    `;

    const countQuery = `
      SELECT COUNT(1) AS total
      FROM ${tableName}
      ${whereSql}
    `;

    const [listResult, countResult] = await Promise.all([
      connection.execute(listQuery, binds),
      connection.execute(countQuery, whereClauses.length > 0 ? { search: binds.search } : {})
    ]);

    const items = normalizeRows(listResult).map((row) => toDoctorDto(row));
    const total = Number(normalizeRows(countResult)?.[0]?.TOTAL || 0);

    return {
      items,
      meta: {
        table: tableName,
        total,
        limit: safeLimit,
        offset: safeOffset,
        hasSearch: Boolean(search),
        searchedBy: nameColumn || null
      }
    };
  } finally {
    if (connection) {
      await connection.close();
    }
  }
}

export async function listUserTables() {
  let connection;

  try {
    connection = await getConnection();

    const result = await connection.execute(
      'SELECT table_name FROM user_tables ORDER BY table_name'
    );

    return normalizeRows(result).map((row) => row.TABLE_NAME);
  } finally {
    if (connection) {
      await connection.close();
    }
  }
}
