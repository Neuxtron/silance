# Silance

A 1:1 private messaging app — monorepo containing a **Go backend** (REST + WebSocket) and a **Flutter client**. Work in progress.

## Features

- **Phone-based authentication** — register/login with a phone number (or username) and password; JWT-secured sessions
- **User directory** — browse all registered users (excluding yourself), with pull-to-refresh
- **Real-time 1:1 chat** — app-wide WebSocket connection; messages routed server-side to the recipient via `room_id`
- **Local notifications** — alerts for incoming messages via `flutter_local_notifications`
- **Calls tab** — placeholder for upcoming voice call support

## Tech Stack

| | Backend | Frontend |
|---|---|---|
| Language | Go | Dart / Flutter |
| Framework | Gin | Flutter (Material, dark theme) |
| Database | PostgreSQL via GORM | — |
| Auth | JWT (`golang-jwt`), bcrypt password hashing | Token storage via `shared_preferences` |
| Realtime | `gorilla/websocket` (single hub, routed by `room_id`) | `web_socket_channel` |
| Notifications | — | `flutter_local_notifications` |
| State / DI | — | `flutter_bloc` (cubits), `get_it` |
| Networking | — | `dio`, `go_router`, `dartz` error handling |
| DevOps | Docker, GHCR, GitHub Actions deploy to VPS | — |

## Project Structure

```
silance/
├── .github/workflows/
│   └── deploy.yml            # Build image → GHCR → deploy to VPS over SSH
│
├── backend/                  # Go API server
│   ├── main.go               # Entry point (DB init → migration → router)
│   ├── Dockerfile            # Multi-stage build (distroless)
│   ├── docker-compose.yml    # api + postgres (bound to 127.0.0.1:8080)
│   ├── modules/
│   │   ├── auth/             # Register, login, profile (controller/service/repository)
│   │   ├── users/            # User listing
│   │   └── messages/         # Single WebSocket hub, per-user clients, room routing
│   ├── middlewares/          # JWT auth middleware
│   ├── database/             # Connection + auto-migration
│   ├── helper/               # JWT, password hashing, env helpers
│   └── router/               # Route registration + CORS
│
└── silance_flutter/          # Flutter app
    ├── env/                  # Env files (.env, .env.local, .env.development)
    └── lib/
        ├── core/             # Router, network client, DI, error handling
        ├── features/
        │   ├── authentication/  # Login & register (clean architecture)
        │   ├── home/            # Messages screen (user list, slivers, refresh)
        │   ├── messaging/       # Socket datasource, chat rooms, room page
        │   ├── notifications/   # Local notifications (init, permission, channels)
        │   └── calls/           # Calls tab (placeholder)
        └── shared/           # Shared entities
```

## Getting Started

### Backend

**Prerequisites:** Go 1.26+, PostgreSQL — or Docker (compose runs Postgres for you)

```bash
cd backend
cp .env.example .env   # fill in DB credentials, JWT_SECRET, etc.

# Option A: run directly
go run main.go

# Option B: run with Docker (api + postgres)
docker compose up
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
cp env/.env.example env/.env   # set BASE_URL and SOCKET_URL
flutter pub get
flutter run
```

Env files live in `env/` and are layered — later files override earlier ones:

1. `env/.env` — base config (committed example: `BASE_URL`, `SOCKET_URL`)
2. `env/.env.development` — environment overrides
3. `env/.env.local` — local overrides, **highest priority** (gitignored)

Supported targets: Android, iOS, web, Linux, macOS, Windows.

## API Reference

Base URL: `{BASE_URL}` (default `/api/v1`)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/auth/register` | — | Create account (`phone`, `password`, `display_name`, optional `username`) |
| `POST` | `/auth/login` | — | Login with `phone` or `username` + `password` |
| `GET` | `/auth/profile` | Bearer token | Get current user's profile |
| `GET` | `/users` | Bearer token | List all users |
| `GET` | `/messages` | Bearer token | Upgrade to WebSocket; send/receive messages routed by `room_id` |

The socket connects once at app start (after login) and stays alive until logout. A `room_id` is derived from the two participants' user IDs; the server delivers the message to the other online participant.

## Deployment

Pushes to `master` touching `backend/**` (or a manual `workflow_dispatch`) trigger `.github/workflows/deploy.yml`, which:

1. Builds the backend Docker image and pushes it to `ghcr.io/neuxtron/silance-api`
2. SSHs into the VPS and runs `docker compose pull api && docker compose up -d api`

The VPS compose stack exposes the API on `127.0.0.1:8080` (put a reverse proxy in front for TLS).

## Testing

```bash
cd silance_flutter
flutter test
```

Covers the authentication repository (login flows) with mocked data sources and JSON fixtures.
