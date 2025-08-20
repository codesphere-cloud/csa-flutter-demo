# Microservice Status Dashboard

A complete Flutter Web and Dart HTTP application for monitoring microservice health status in real-time.

## What This Template Does

This is a **production-ready foundation** for building service monitoring dashboards. It demonstrates:

- **Real-time health monitoring** of multiple services/APIs
- **Visual status indicators** (green=online, red=offline, grey=checking)
- **Full-stack architecture** with Dart backend and Flutter frontend
- **Self-monitoring** - the backend monitors its own health
- **Extensible design** for adding custom services and alerting

## Real-World Use Cases

**DevOps & SRE Teams:**
- Monitor critical APIs, databases, and external dependencies
- Create status pages for incident response
- Verify service health after deployments
- Track uptime of microservices in distributed systems

**Development Teams:**
- Monitor development/staging environments
- Check service dependencies before releases
- Create internal dashboards for service visibility

**Business Operations:**
- Public status pages for customers
- Monitor third-party service dependencies
- Track critical business service availability

## Project Structure

```
/
├── backend/
│   ├── pubspec.yaml              # Dart dependencies
│   └── bin/server_simple.dart    # HTTP API server (port 3000)
├── frontend/
│   ├── pubspec.yaml              # Flutter dependencies  
│   ├── lib/main.dart             # Flutter Web dashboard
│   └── web/                      # Web assets (HTML, manifest, icons)
├── configuration.nix             # Codesphere environment setup
└── ci.yml                        # Deployment configuration
```

## Features

### Backend (Dart HTTP Server)
- Lightweight HTTP server running on port 3000
- **GET `/api/services`** - Returns list of services to monitor
- **GET `/api/health`** - Health check endpoint for the backend itself
- CORS headers configured for cross-origin requests
- No external dependencies (uses built-in `dart:io`)
- Monitored services include:
  - **Dashboard Backend** (self-monitoring via `/api/health`)
  - **Google DNS** (8.8.8.8)
  - **Public APIs** (api.publicapis.org)
  - **GitHub API** (api.github.com)
  - **JSONPlaceholder** (jsonplaceholder.typicode.com)
  - **HttpBin** (httpbin.org)

### Frontend (Flutter Web)
- Material Design 3 dashboard interface
- **Real-time health monitoring** with automatic status updates
- **Visual status indicators:** Loading (grey spinner), Online (green), Offline (red)
- **Summary statistics** showing total/online/offline/checking counts
- **Manual refresh** functionality and per-service re-check
- **Responsive design** with cards and interactive list tiles
- **Progressive Web App** (PWA) capabilities

## Development Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Running the Application

1. **Start the Backend Server:**
   ```bash
   cd backend
   dart run bin/server_simple.dart
   ```
   Server will start on `http://localhost:3000`

2. **Start the Frontend (Development):**
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

### GET /api/services
Returns a JSON array of service objects to monitor:

```json
[
  {
    "name": "Dashboard Backend",
    "url": "/api/health"
  },
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

### GET /api/health
Backend self-monitoring endpoint:

```json
{
  "status": "healthy",
  "timestamp": "2025-08-20T10:30:00.000Z",
  "service": "microservice-dashboard-backend"
}
```

## Health Check Logic

The frontend performs the following health monitoring:
1. Fetches service list from backend `/api/services` endpoint
2. For each service, makes a HEAD request to the service URL
3. **Status 200-299:** Service is marked as "Online" (green)
4. **Any error or non-2xx status:** Service is marked as "Offline" (red)
5. **During check:** Service shows "Checking..." (grey with spinner)
6. **Self-monitoring:** Backend monitors its own health via `/api/health`

## Extending the Dashboard

### Adding Your Own Services

Replace the demo services in `backend/bin/server_simple.dart`:

```dart
final services = [
  {
    'name': 'Dashboard Backend',
    'url': '/api/health',  // Self-monitoring
  },
  {
    'name': 'User API',
    'url': 'https://api.yourapp.com/users/health',
  },
  {
    'name': 'Payment Service',
    'url': 'https://payments.yourapp.com/health',
  },
  {
    'name': 'Database',
    'url': 'https://db.yourapp.com/ping',
  },
  // Add your services here
];
```

### Potential Extensions

- **Alerting:** Send notifications when services go down (Slack, email, webhooks)
- **Historical data:** Store uptime/downtime history in a database
- **Response time tracking:** Measure and display service response times
- **Custom health checks:** Support different HTTP methods, authentication, custom headers
- **Dashboard themes:** Dark mode, custom branding, multiple dashboard views
- **User management:** Authentication, role-based access, team dashboards
