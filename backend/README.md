# CV Maker Backend

Phase 2 provides the independently deployable Express API foundation for the Flutter app.

## Run locally

```powershell
cd backend
npm install
npm run dev
```

The API listens on `http://localhost:4000` by default.

- `GET /health` reports API and MongoDB connection status.
- `GET /api/templates` returns the initial template catalog.
- Authenticated `/api/cvs` routes provide CV list, create, read, update, delete, and duplicate operations.
- Authenticated `/api/subscription/status` returns provider-neutral plan entitlements; `/api/subscription/cancel` provides the cancellation boundary for a future billing provider.
- Premium authenticated `/api/ai` routes provide summary, improvement, tailoring, ATS, and cover-letter generation through the server-side Gemini adapter.

The real `.env` file is intentionally ignored by Git. Keep MongoDB and JWT credentials server-side and rotate any credentials that have been shared outside your secret manager.
