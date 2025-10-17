# CSA Flutter Demo

Simple showcase for Flutter on Codesphere using the default Flutter Application template. 

## Development Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Running the Application locally

1. **Start the Frontend (Development):**
   ```bash
   cd frontend
   flutter pub get
   flutter run -d web-server --web-port 8080
   ```
   Frontend will be available at `http://localhost:8080`

### Running in Codesphere

#### Development

- The `ci.demo.yml` prepare step installs Flutter
- The run step starts the Flutter development server (`flutter run -d web-server`)
- Execute both prepare and run step and use `Open Deployment`