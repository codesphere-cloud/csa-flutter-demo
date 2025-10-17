# CSA Flutter Demo

Simple showcase for Flutter on Codesphere using the default Flutter Application template. 

## Development Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Running the Application locally

```bash
cd demo_app
flutter pub get
flutter run -d web-server --web-port 8080
```
App will be available at `http://localhost:8080`

### Buiding the WebApp

```bash
cd demo_app
flutter clean && flutter pub get
flutter build web
```
The built app can be found and served from `demo_app/build/web`, e.g. with simple webserver. 

### Building the Android APK

```bash
cd demo_app
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
```
This will create a Nix `devShell` environment with Flutter and the Android SDK installed. 
The Android SDK has various configuration option, like the API levels, which are containing in the Nix flake `flake.nix`. 

When in the devShell: 
```bash
cd demo_app
flutter build apk --release
```

### Running in Codesphere

#### Development

- The `ci.demo.yml` prepare step installs Flutter
- The run step starts the Flutter development server (`flutter run -d web-server`)
- Execute both prepare and run step and use `Open Deployment`

#### Production

- The `ci.yml` prepare step installs Flutter and builds the App
- The run step starts a Python web server in the build output
- Execute both prepare and run step and use `Open Deployment`