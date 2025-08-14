# Microservice Status Dashboard

A complete Flutter Web and Dart Shelf application for monitoring microservice health status.

## Project Structure

```
/
├── backend/
│   ├── pubspec.yaml          # Backend dependencies (shelf, shelf_router)
│   └── bin/server.dart       # Dart Shelf API server
└── frontend/
    ├── pubspec.yaml          # Frontend dependencies (flutter, http)
    └── lib/main.dart         # Flutter Web application
```

## Features

### Backend (Dart Shelf API)
- RESTful API server running on port 8080
- GET `/api/services` endpoint returning JSON list of services
- CORS headers configured for cross-origin requests
- Hardcoded service list including:
  - Google DNS (8.8.8.8)
  - Public API (api.publicapis.org)
  - GitHub API
  - JSONPlaceholder
  - HttpBin

### Frontend (Flutter Web)
- Material Design 3 dashboard interface
- Real-time service health monitoring
- Status indicators: Loading (grey), Online (green), Offline (red)
- Summary statistics showing total, online, offline, and checking services
- Manual refresh functionality
- Individual service health re-check on tap
- Responsive design with cards and list tiles

## Development Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Running the Application

1. **Start the Backend Server:**
   ```bash
   cd backend
   dart pub get
   dart run bin/server.dart
   ```
   Server will start on `http://localhost:8080`

2. **Start the Frontend (Development):**
   ```bash
   cd frontend
   flutter pub get
   flutter run -d web-server --web-port 3000
   ```
   Frontend will be available at `http://localhost:3000`

### Building for Production

1. **Build Frontend:**
   ```bash
   cd frontend
   flutter build web
   ```
   Static files will be generated in `frontend/build/web/`

2. **For Codesphere Deployment:**
   - The `ci.yml` prepare step should run `flutter build web` in the frontend directory
   - The run step should serve static files from `frontend/build/web`
   - Backend should be configured to run `dart run bin/server.dart` in the backend directory

## API Endpoints

### GET /api/services
Returns a JSON array of service objects:

```json
[
  {
    "name": "Google DNS",
    "url": "https://8.8.8.8"
  },
  {
    "name": "Public API", 
    "url": "https://api.publicapis.org/entries"
  }
]
```

## Health Check Logic

The frontend performs the following health checks:
1. Fetches service list from backend `/api/services` endpoint
2. For each service, makes a HEAD request to the service URL
3. Status 200-299: Service is marked as "Online" (green)
4. Any error or non-2xx status: Service is marked as "Offline" (red)
5. During check: Service shows "Checking..." (grey with spinner)

## Customization

To add more services, modify the `services` array in `backend/bin/server.dart`:

```dart
final services = [
  {
    'name': 'Your Service Name',
    'url': 'https://your-service-url.com',
  },
  // Add more services here
];
```
