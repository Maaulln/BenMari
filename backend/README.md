# BenMari Backend

Backend API untuk aplikasi Flutter BenMari.

## Setup

1. Masuk ke folder backend.
2. Salin `.env.example` menjadi `.env`.
3. Isi credential Oracle kamu.
4. Install dependency:

```bash
npm install
```

5. Jalankan server:

```bash
npm run dev
```

## Endpoint

- `GET /api/health` - cek server berjalan.
- `GET /api/db/ping` - cek koneksi ke Oracle menggunakan `SELECT 1 FROM dual`.
- `GET /api/doctors` - ambil daftar dokter dari tabel Oracle.
- `GET /api/doctors?search=budi&limit=10&offset=0` - cari dokter by nama dengan pagination.
- `GET /api/doctors/meta/tables` - lihat semua nama tabel pada schema user aktif.
- `GET /api/appointments?pasienId=1` - ambil list appointment milik pasien.
- `POST /api/appointments` - buat appointment baru.
- `POST /api/auth/register-pasien` - registrasi akun pasien baru (insert ke tabel `PASIEN` di Oracle).
- `PUT /api/auth/pasien/profile` - update profil pasien (nama/email/telepon/alamat/jenis kelamin/foto base64) via JWT pasien.

Contoh body `POST /api/auth/register-pasien`:

```json
{
	"name": "Budi Santoso",
	"email": "budi@email.com",
	"password": "password123",
	"phone": "081234567890",
	"address": "Jl. Merdeka No. 10",
	"birthDate": "1998-05-20",
	"gender": "L",
	"nik": "3524012005980001",
	"bloodType": "O"
}
```

Contoh body `POST /api/appointments`:

```json
{
	"pasienId": 1,
	"dokterId": 1,
	"tanggalAppointment": "2026-04-25",
	"jamAppointment": "09:30",
	"keluhanAwal": "Demam dan batuk",
	"catatan": "Datang 15 menit lebih awal"
}
```

Contoh body `PUT /api/auth/pasien/profile`:

```json
{
	"name": "Andi Firmansyah",
	"email": "andi@email.com",
	"phone": "081234567890",
	"address": "Jl. Melati No. 12",
	"gender": "L",
	"photoBase64": "iVBORw0KGgoAAAANSUhEUgAA..."
}
```

## Konfigurasi Tabel Dokter

- Default backend akan mencoba mencari tabel: `DOKTER,DOKTERS,DOCTOR,DOCTORS,TB_DOKTER,M_DOKTER`.
- Kalau nama tabel kamu beda, isi `ORACLE_DOCTOR_TABLE` di `.env`, contoh `ORACLE_DOCTOR_TABLE=MASTER_DOKTER`.
