# BenMari Authentication System (v1.0)

## Overview
Sistem login role-based dengan 3 jenis akun: **Pasien**, **Dokter**, dan **Admin**. Menggunakan JWT token dengan validasi di backend.

---

## Backend Implementation

### 1. Database Schema Updates
Tambahan kolom untuk autentikasi:

**PASIEN Table:**
- `EMAIL_PASIEN VARCHAR2(100)` - Email untuk login
- `PASSWORD_PASIEN VARCHAR2(255)` - Password (plaintext, recommend bcrypt in production)

**DOKTER Table:**
- `EMAIL_DOKTER VARCHAR2(100)` - Email untuk login  
- `PASSWORD_DOKTER VARCHAR2(255)` - Password

**ADMIN Table (new):**
- `ID_ADMIN NUMBER PRIMARY KEY`
- `NAMA_ADMIN VARCHAR2(100)`
- `EMAIL_ADMIN VARCHAR2(100) UNIQUE`
- `PASSWORD_ADMIN VARCHAR2(255)`
- `NO_TELP_ADMIN VARCHAR2(20)`

### 2. Login Endpoints

#### POST /api/auth/login-pasien
```json
{
  "email": "andi@email.com",
  "password": "password123"
}
```
Response (200 OK):
```json
{
  "success": true,
  "message": "Login berhasil",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "1",
    "name": "Budi Santoso",
    "email": "andi@email.com",
    "phone": "081234567890",
    "address": "Jl. Merdeka No.10, Lamongan",
    "birthDate": "1990-05-14",
    "role": "pasien"
  }
}
```

#### POST /api/auth/login-dokter
```json
{
  "email": "dr.budi@klinik.com",
  "password": "password123"
}
```
Response returns doctor data with `role: "dokter"`

#### POST /api/auth/login-admin
```json
{
  "email": "admin@klinik.com",
  "password": "password123"
}
```
Response returns admin data with `role: "admin"`

#### GET /api/auth/verify
Verify JWT token validity
```
Headers: Authorization: Bearer {token}
```

### 3. Demo Credentials
| Role | Email | Password | Status |
|------|-------|----------|--------|
| Pasien | andi@email.com | password123 | ✅ Active |
| Dokter | dr.budi@klinik.com | password123 | ✅ Active |
| Admin | admin@klinik.com | password123 | ✅ Active |

---

## Flutter Implementation

### 1. Login Page Structure

**File:** `lib/login_page.dart`

Features:
- Role selector (Pasien/Dokter/Admin) dengan warna berbeda
  - Pasien: Green (#009966)
  - Dokter: Blue (#155DFC)  
  - Admin: Red (#D0142A)
- Demo credentials auto-fill saat role berubah
- Error messages display
- Loading state indicator

### 2. Authentication API Client

**File:** `lib/auth_api.dart`

Methods:
- `AuthApi.loginPasien(email, password)` → LoginResponse
- `AuthApi.loginDokter(email, password)` → LoginResponse
- `AuthApi.loginAdmin(email, password)` → LoginResponse
- `AuthApi.verifyToken(token)` → LoginResponse

Base URL auto-detection:
- Windows/Desktop: `http://localhost:3000`
- Android Emulator: `http://10.0.2.2:3000`
- Override: `flutter run --dart-define=API_BASE_URL=http://your-url:3000`

### 3. Auth State Management

**File:** `lib/auth_provider.dart`

`AuthProvider` class (extends `ChangeNotifier`):
```dart
// Getters
- token: String?
- user: Map<String, dynamic>?
- role: String?
- isAuthenticated: bool

// Methods
- setAuthData(token, user, role)
- logout()
- isAdmin() / isDoctor() / isPatient()
```

### 4. Main App Shell

**File:** `lib/main.dart`

`AppShell` widget handles navigation based on auth state:
- Not authenticated → `LoginPage`
- Authenticated as `pasien` → `PatientHomePage`
- Authenticated as `dokter` → `DokterHomePage`
- Authenticated as `admin` → AdminHomePage (coming soon)

---

## Security Considerations

### Current (Development)
- Passwords stored as plaintext in database ⚠️
- JWT secret hardcoded in .env ⚠️
- No HTTPS ⚠️

### Recommended for Production
1. Hash passwords with bcryptjs
2. Use strong JWT_SECRET from environment
3. Implement HTTPS/TLS
4. Add rate limiting on auth endpoints
5. Implement refresh tokens
6. Add password validation rules
7. Log failed login attempts
8. Implement account lockout after N failed attempts

---

## Testing the System

### 1. Start Backend
```bash
cd backend
npm run dev
```

### 2. Run Database Setup (first time)
```bash
node setup-database.js
```

### 3. Test via cURL
```bash
# Patient login
curl -X POST http://localhost:3000/api/auth/login-pasien \
  -H "Content-Type: application/json" \
  -d '{"email":"andi@email.com","password":"password123"}'

# Doctor login
curl -X POST http://localhost:3000/api/auth/login-dokter \
  -H "Content-Type: application/json" \
  -d '{"email":"dr.budi@klinik.com","password":"password123"}'

# Admin login
curl -X POST http://localhost:3000/api/auth/login-admin \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@klinik.com","password":"password123"}'
```

### 4. Start Flutter App
```bash
flutter run
```
- Select role and login with demo credentials
- App routes to appropriate home page based on role

---

## Next Steps

1. **Test on real device** - Verify login flow on Android device
2. **Implement Admin dashboard** - Create AdminHomePage with user management
3. **Add password hashing** - Migrate to bcryptjs
4. **Logout functionality** - Add logout button in home pages
5. **Session persistence** - Save token to local storage (shared_preferences)
6. **Token refresh** - Implement refresh token mechanism
7. **API authentication** - Protect other endpoints with JWT verification middleware

---

## Files Modified/Created

### Backend
- `backend/.env` - Added JWT_SECRET
- `backend/package.json` - Added jsonwebtoken, bcryptjs
- `backend/src/repositories/authRepository.js` - NEW
- `backend/src/routes/authRoutes.js` - NEW
- `backend/setup-database.js` - NEW
- `backend/src/app.js` - Added auth routes

### Flutter
- `lib/login_page.dart` - NEW (detailed login UI)
- `lib/auth_api.dart` - NEW (API client)
- `lib/auth_provider.dart` - NEW (state management)
- `lib/main.dart` - Modified (app shell navigation)
- `lib/patient/patient_home_page.dart` - Modified (accept token/user params)
- `lib/dokter/dokter_home_page.dart` - Modified (accept token/user params)
- `pubspec.yaml` - Already has http dependency

---

Generated: April 21, 2026
