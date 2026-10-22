# Silance

A 1:1 private messaging app — monorepo containing a **Go backend** (REST + WebSocket) and a **Flutter client**. Work in progress.

## Features

- **Phone-based authentication** — register/login with a phone number (or username) and password; JWT-secured sessions
- **User directory** — browse all registered users to start a conversation
- **1:1 WebSocket chat** — private rooms capped at two participants (experimental)
- **Calls tab** — placeholder for upcoming voice call support

## Tech Stack

| | Backend | Frontend |
|---|---|---|
| Language | Go | Dart / Flutter |
| Framework | Gin | Flutter (Material, dark theme) |
| Database | PostgreSQL via GORM | — |
| Auth | JWT (`golang-jwt`), bcrypt password hashing | Token storage via `shared_preferences` |
| Realtime | `gorilla/websocket` (room hubs) | — |
| State / DI | — | `flutter_bloc` (cubits), `get_it` |
| Networking | — | `dio`, `go_router`, `dartz` error handling |

## Project Structure

```
silance/
├── backend/                  # Go API server
│   ├── main.go               # Entry point (DB init → migration → router)
│   ├── modules/
│   │   ├── auth/             # Register, login, profile (controller/service/repository)
│   │   ├── users/            # User listing
│   │   └── messages/         # WebSocket hubs, one room per 1:1 chat
│   ├── middlewares/          # JWT auth middleware
│   ├── database/             # Connection + auto-migration
│   ├── helper/               # JWT, password hashing, env helpers
│   └── router/               # Route registration + CORS
│
└── silance_flutter/          # Flutter app
    └── lib/
        ├── core/             # Router, network client, DI, error handling
        ├── features/
        │   ├── authentication/  # Login & register (clean architecture)
        │   ├── home/            # Messages screen (user list)
        │   └── calls/           # Calls tab (placeholder)
        └── shared/           # Shared entities
```

## Getting Started

### Backend

**Prerequisites:** Go 1.26+, PostgreSQL

```bash
cd backend
cp .env.example .env   # fill in DB credentials, JWT_SECRET, etc.
go run main.go
```

The API serves under `/api/v1` on `:8080` (configurable via `.env`). Migrations run automatically on startup.

| Variable | Description |
|---|---|
| `APP_PORT` | Port the server listens on (e.g. `:8080`) |
| `API_VERSION` | Base path (e.g. `/api/v1`) |
| `JWT_SECRET` | Secret for signing JWTs |
| `APP_ENV` | `development` or `production` |
| `DB_USERNAME` / `DB_PASSWORD` / `DB_HOST` / `DB_NAME` | PostgreSQL connection |

### Flutter App

**Prerequisites:** Flutter SDK 3.13+

```bash
cd silance_flutter
cp .env.example .env   # set BASE_URL to the backend, e.g. http://localhost:8080/api/v1
flutter pub get
flutter run
```

Supported targets: Android, iOS, web, Linux, macOS, Windows.

## API Reference

Base URL: `{BASE_URL}` (default `/api/v1`)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/auth/register` | — | Create account (`phone`, `password`, `display_name`, optional `username`) |
| `POST` | `/auth/login` | — | Login with `phone` or `username` + `password` |
| `GET` | `/auth/profile` | Bearer token | Get current user's profile |
| `GET` | `/users` | Bearer token | List all users |
| `GET` | `/messages/ws/:room` | — | Upgrade to WebSocket; joins a 1:1 room (max 2 clients) |

## Testing

```bash
cd silance_flutter
flutter test
```

Covers the authentication repository (login flows) with mocked data sources and JSON fixtures.
