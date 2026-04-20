# AI-Powered Food Waste Exchange MVP

A Flutter + Node.js application to connect food donors with receivers, powered by AI for spoilage prediction and geospatial matching.

## Tech Stack
- **Frontend**: Flutter Web + Mobile (Riverpod, GoRouter)
- **Backend**: Node.js (NestJS, Prisma, PostGIS)
- **AI**: Hugging Face Inference API
- **Deployment**: Vercel (Split Project Strategy)
- **Database**: PostgreSQL (Supabase/Neon)

## Project Structure
- `/flutter_app` - Flutter frontend.
- `/backend` - NestJS API.

## Setup Instructions

### Backend
1. `cd backend`
2. `npm install`
3. Create `.env` from `.env.example`.
4. Run `npx prisma db push` to setup database.
5. `npm run start:dev`

### Frontend
1. `cd flutter_app`
2. `flutter pub get`
3. `flutter run -d chrome` (for web)

## Deployment to Vercel

### 1. Backend Project
- Create a new project on Vercel and link the `backend` directory.
- Use **Node.js** as the framework.
- Set environment variables: `DATABASE_URL`, `HF_API_KEY`.

### 2. Frontend Project
- Create a new project on Vercel and link the `flutter_app` directory.
- **Framework Preset**: `Other`
- **Build Command**: `flutter/bin/flutter build web --release`
- **Output Directory**: `build/web`
- **Install Command**:
  ```bash
  if cd flutter; then git pull && cd .. ; else git clone https://github.com/flutter/flutter.git; fi && ls && flutter/bin/flutter doctor && flutter/bin/flutter clean && flutter/bin/flutter config --enable-web
  ```

## Environment Variables (.env)
- `DATABASE_URL`: PostgreSQL connection string with PostGIS enabled.
- `HF_API_KEY`: Hugging Face Inference API Key.
- `SUPABASE_URL`: Supabase project URL.
- `SUPABASE_ANON_KEY`: Supabase anonymous key.
- `GOOGLE_MAPS_API_KEY`: API key for Google Maps.
