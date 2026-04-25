-- ============================================================================
-- BenMari Database Setup Script
-- Adds authentication fields and demo users
-- ============================================================================

-- ============================================================================
-- 1. Add EMAIL and PASSWORD columns to PASIEN table (if not exists)
-- ============================================================================

BEGIN
  BEGIN
    ALTER TABLE PASIEN ADD EMAIL_PASIEN VARCHAR2(100);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1430 THEN
        -- Column already exists
        NULL;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

BEGIN
  BEGIN
    ALTER TABLE PASIEN ADD PASSWORD_PASIEN VARCHAR2(255);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1430 THEN
        -- Column already exists
        NULL;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

BEGIN
  BEGIN
    ALTER TABLE PASIEN ADD FOTO_PROFIL_BASE64 CLOB;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1430 THEN
        -- Column already exists
        NULL;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-- Create unique index on EMAIL_PASIEN
BEGIN
  BEGIN
    CREATE UNIQUE INDEX IDX_PASIEN_EMAIL ON PASIEN(EMAIL_PASIEN);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        -- Index already exists
        NULL;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-- ============================================================================
-- 2. Add EMAIL and PASSWORD columns to DOKTER table (if not exists)
-- ============================================================================

BEGIN
  BEGIN
    ALTER TABLE DOKTER ADD EMAIL_DOKTER VARCHAR2(100);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1430 THEN
        -- Column already exists
        NULL;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

BEGIN
  BEGIN
    ALTER TABLE DOKTER ADD PASSWORD_DOKTER VARCHAR2(255);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1430 THEN
        -- Column already exists
        NULL;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-- Create unique index on EMAIL_DOKTER
BEGIN
  BEGIN
    CREATE UNIQUE INDEX IDX_DOKTER_EMAIL ON DOKTER(EMAIL_DOKTER);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        -- Index already exists
        NULL;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-- ============================================================================
-- 3. Create ADMIN table (if not exists)
-- ============================================================================

BEGIN
  DECLARE
    table_exists EXCEPTION;
    PRAGMA EXCEPTION_INIT(table_exists, -955);
  BEGIN
    CREATE TABLE ADMIN (
      ID_ADMIN NUMBER PRIMARY KEY,
      NAMA_ADMIN VARCHAR2(100) NOT NULL,
      EMAIL_ADMIN VARCHAR2(100) NOT NULL UNIQUE,
      PASSWORD_ADMIN VARCHAR2(255) NOT NULL,
      NO_TELP_ADMIN VARCHAR2(20),
      CREATED_AT DATE DEFAULT SYSDATE,
      UPDATED_AT DATE DEFAULT SYSDATE
    );
  EXCEPTION
    WHEN table_exists THEN
      NULL;
  END;
END;
/

-- Create sequence for ADMIN table if not exists
BEGIN
  DECLARE
    sequence_exists EXCEPTION;
    PRAGMA EXCEPTION_INIT(sequence_exists, -955);
  BEGIN
    CREATE SEQUENCE SEQ_ADMIN START WITH 1 INCREMENT BY 1;
  EXCEPTION
    WHEN sequence_exists THEN
      NULL;
  END;
END;
/

-- ============================================================================
-- 4. Insert Demo Users (if not already exist)
-- ============================================================================

-- Demo Patient
BEGIN
  INSERT INTO PASIEN (ID_PASIEN, NAMA_PASIEN, EMAIL_PASIEN, PASSWORD_PASIEN)
  SELECT 1, 'Andi Firmansyah', 'andi@email.com', 'password123'
  FROM DUAL
  WHERE NOT EXISTS (
    SELECT 1 FROM PASIEN WHERE EMAIL_PASIEN = 'andi@email.com'
  );
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    NULL;
END;
/

-- Demo Doctor
BEGIN
  INSERT INTO DOKTER (ID_DOKTER, NAMA_DOKTER, EMAIL_DOKTER, PASSWORD_DOKTER, SPESIALISASI, IS_ACTIVE)
  SELECT 1, 'Dr. Budi Santoso', 'dr.budi@klinik.com', 'password123', 'Sp.PD', 1
  FROM DUAL
  WHERE NOT EXISTS (
    SELECT 1 FROM DOKTER WHERE EMAIL_DOKTER = 'dr.budi@klinik.com'
  );
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    NULL;
END;
/

-- Demo Admin
BEGIN
  INSERT INTO ADMIN (ID_ADMIN, NAMA_ADMIN, EMAIL_ADMIN, PASSWORD_ADMIN, NO_TELP_ADMIN)
  SELECT 1, 'Admin Klinik', 'admin@klinik.com', 'password123', '021-1234567'
  FROM DUAL
  WHERE NOT EXISTS (
    SELECT 1 FROM ADMIN WHERE EMAIL_ADMIN = 'admin@klinik.com'
  );
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    NULL;
END;
/

-- ============================================================================
-- 5. Display verification results
-- ============================================================================
SELECT 'PASIEN Demo Users:' as section FROM DUAL;
SELECT ID_PASIEN, NAMA_PASIEN, EMAIL_PASIEN FROM PASIEN WHERE EMAIL_PASIEN LIKE '%@%';

SELECT 'DOKTER Demo Users:' as section FROM DUAL;
SELECT ID_DOKTER, NAMA_DOKTER, EMAIL_DOKTER FROM DOKTER WHERE EMAIL_DOKTER LIKE '%@%';

SELECT 'ADMIN Users:' as section FROM DUAL;
SELECT ID_ADMIN, NAMA_ADMIN, EMAIL_ADMIN FROM ADMIN WHERE EMAIL_ADMIN LIKE '%@%';

EXIT;
