# CSA Flutter Demo

## Development Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Running the Application

1. **Start the Frontend (Development):**
   ```bash
   cd frontend
   flutter pub get
   flutter run -d web-server --web-port 8080
   ```
   Frontend will be available at `http://localhost:8080`

### Building for Production

1. **Build Frontend:**
   ```bash
   cd frontend
   flutter build web
   ```
   Static files will be generated in `frontend/build/web/`

2. **For Codesphere Deployment:**
   - The `ci.yml` prepare step runs `flutter build web` in the frontend directory
   - Both services run on port 3000 with path-based routing:
     - Frontend static files: `/` 
     - Backend API: `/api/*`

## API Endpoints

