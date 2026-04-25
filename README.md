# BenMari

Flutter app for klinik BenMari.

## Project Structure

- `lib/` contains the Flutter UI.
- `backend/` contains the Node.js + Express API that connects to Oracle.

## Backend

The backend exposes:

- `GET /api/health` to check whether the API is running.
- `GET /api/db/ping` to verify Oracle connectivity using `SELECT 1 FROM dual`.

See [backend/README.md](backend/README.md) for setup instructions.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
