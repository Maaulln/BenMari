import oracledb from 'oracledb';

async function setupDatabase() {
  console.log('Starting database setup...');

  try {
    // Initialize connection pool
    await oracledb.createPool({
      connectString: 'localhost:1522/orcl21',
      user: 'C##KLINIK_ADMIN',
      password: 'KlinikAdmin123',
      poolAlias: 'SETUP_POOL',
      poolMin: 1,
      poolMax: 1,
    });

    console.log('Connected to Oracle Database');

    const conn = await oracledb.getConnection('SETUP_POOL');

    // Set output format
    conn.outFormat = oracledb.OUT_FORMAT_OBJECT;

    // First, check table structure
    console.log('\n--- Table Structure ---');
    let tempResult = await conn.execute(
      `SELECT * FROM PASIEN WHERE ROWNUM <= 1`
    );
    const pasienColumns = tempResult.metaData?.map((m) => m.name) || [];
    console.log('PASIEN columns:', pasienColumns.join(', '));

    tempResult = await conn.execute(
      `SELECT * FROM DOKTER WHERE ROWNUM <= 1`
    );
    const dokterColumns = tempResult.metaData?.map((m) => m.name) || [];
    console.log('DOKTER columns:', dokterColumns.join(', '));

    // Add EMAIL_PASIEN column if not exists
    try {
      await conn.execute(
        `ALTER TABLE PASIEN ADD EMAIL_PASIEN VARCHAR2(100)`
      );
      console.log('✓ Added EMAIL_PASIEN column to PASIEN table');
    } catch (err) {
      if (err.errorNum !== 1430) {
        console.log('• EMAIL_PASIEN column already exists or error:', err.message);
      }
    }

    // Add PASSWORD_PASIEN column if not exists
    try {
      await conn.execute(
        `ALTER TABLE PASIEN ADD PASSWORD_PASIEN VARCHAR2(255)`
      );
      console.log('✓ Added PASSWORD_PASIEN column to PASIEN table');
    } catch (err) {
      if (err.errorNum !== 1430) {
        console.log('• PASSWORD_PASIEN column already exists or error:', err.message);
      }
    }

    // Add EMAIL_DOKTER column if not exists
    try {
      await conn.execute(
        `ALTER TABLE DOKTER ADD EMAIL_DOKTER VARCHAR2(100)`
      );
      console.log('✓ Added EMAIL_DOKTER column to DOKTER table');
    } catch (err) {
      if (err.errorNum !== 1430) {
        console.log('• EMAIL_DOKTER column already exists or error:', err.message);
      }
    }

    // Add PASSWORD_DOKTER column if not exists
    try {
      await conn.execute(
        `ALTER TABLE DOKTER ADD PASSWORD_DOKTER VARCHAR2(255)`
      );
      console.log('✓ Added PASSWORD_DOKTER column to DOKTER table');
    } catch (err) {
      if (err.errorNum !== 1430) {
        console.log('• PASSWORD_DOKTER column already exists or error:', err.message);
      }
    }

    // Create ADMIN table if not exists
    try {
      await conn.execute(`
        CREATE TABLE ADMIN (
          ID_ADMIN NUMBER PRIMARY KEY,
          NAMA_ADMIN VARCHAR2(100) NOT NULL,
          EMAIL_ADMIN VARCHAR2(100) NOT NULL UNIQUE,
          PASSWORD_ADMIN VARCHAR2(255) NOT NULL,
          NO_TELP_ADMIN VARCHAR2(20),
          CREATED_AT DATE DEFAULT SYSDATE,
          UPDATED_AT DATE DEFAULT SYSDATE
        )
      `);
      console.log('✓ Created ADMIN table');
    } catch (err) {
      if (err.errorNum !== 955) {
        console.log('• ADMIN table already exists or error:', err.message);
      }
    }

    // Create sequence for ADMIN if not exists
    try {
      await conn.execute(`CREATE SEQUENCE SEQ_ADMIN START WITH 1 INCREMENT BY 1`);
      console.log('✓ Created SEQ_ADMIN sequence');
    } catch (err) {
      if (err.errorNum !== 955) {
        console.log('• SEQ_ADMIN sequence already exists or error:', err.message);
      }
    }

    // Update PASIEN demo user
    console.log('\nSetting up demo users...');
    
    // Check if patient exists, if not insert
    let result = await conn.execute(
      `SELECT COUNT(*) as cnt FROM PASIEN WHERE EMAIL_PASIEN = :email`,
      { email: 'andi@email.com' }
    );

    if (result.rows[0][0] === 0) {
      // Find first PASIEN and update their email/password
      await conn.execute(
        `UPDATE PASIEN SET EMAIL_PASIEN = :email, PASSWORD_PASIEN = :password WHERE ROWNUM <= 1`,
        {
          email: 'andi@email.com',
          password: 'password123'
        }
      );
      console.log('✓ Created demo PASIEN: andi@email.com / password123');
    } else {
      console.log('✓ Demo PASIEN already exists: andi@email.com');
    }

    // Check if doctor exists, if not insert
    result = await conn.execute(
      `SELECT COUNT(*) as cnt FROM DOKTER WHERE EMAIL_DOKTER = :email`,
      { email: 'dr.budi@klinik.com' }
    );

    if (result.rows[0][0] === 0) {
      // Find first DOKTER and update their email/password
      await conn.execute(
        `UPDATE DOKTER SET EMAIL_DOKTER = :email, PASSWORD_DOKTER = :password WHERE ROWNUM <= 1`,
        {
          email: 'dr.budi@klinik.com',
          password: 'password123'
        }
      );
      console.log('✓ Created demo DOKTER: dr.budi@klinik.com / password123');
    } else {
      console.log('✓ Demo DOKTER already exists: dr.budi@klinik.com');
    }

    // Check if admin exists, if not insert
    result = await conn.execute(
      `SELECT COUNT(*) as cnt FROM ADMIN WHERE EMAIL_ADMIN = :email`,
      { email: 'admin@klinik.com' }
    );

    if (result.rows[0][0] === 0) {
      // Insert new admin
      await conn.execute(
        `INSERT INTO ADMIN (ID_ADMIN, NAMA_ADMIN, EMAIL_ADMIN, PASSWORD_ADMIN, NO_TELP_ADMIN)
         VALUES (SEQ_ADMIN.NEXTVAL, :name, :email, :password, :phone)`,
        {
          name: 'Admin Klinik',
          email: 'admin@klinik.com',
          password: 'password123',
          phone: '021-1234567'
        }
      );
      console.log('✓ Created demo ADMIN: admin@klinik.com / password123');
    } else {
      console.log('✓ Demo ADMIN already exists: admin@klinik.com');
    }

    // Commit transaction
    await conn.commit();

    // Verify setup
    console.log('\n--- Verification ---');
    
    result = await conn.execute(
      `SELECT NAMA_LENGKAP, EMAIL_PASIEN FROM PASIEN WHERE EMAIL_PASIEN IS NOT NULL`
    );
    console.log('PASIEN with email:', result.rows.map((r) => `${r[0]} (${r[1]})`).join(', '));

    result = await conn.execute(
      `SELECT NAMA_DOKTER, EMAIL_DOKTER FROM DOKTER WHERE EMAIL_DOKTER IS NOT NULL`
    );
    console.log('DOKTER with email:', result.rows.map((r) => `${r[0]} (${r[1]})`).join(', '));

    result = await conn.execute(
      `SELECT NAMA_ADMIN, EMAIL_ADMIN FROM ADMIN WHERE EMAIL_ADMIN IS NOT NULL`
    );
    console.log('ADMIN accounts:', result.rows.map((r) => `${r[0]} (${r[1]})`).join(', '));

    await conn.close();
    console.log('\n✓ Database setup completed successfully!');

    process.exit(0);
  } catch (err) {
    console.error('❌ Setup error:', err);
    process.exit(1);
  }
}

setupDatabase();
