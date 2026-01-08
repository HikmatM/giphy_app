# Giphy Search App

A modern Flutter application for searching and viewing GIFs from Giphy API. Built with clean architecture principles, featuring state management with BLoC, dependency injection, and comprehensive error handling.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Running the App](#running-the-app)
- [Testing](#testing)
- [Code Generation](#code-generation)
- [Key Design Decisions](#key-design-decisions)

## ✨ Features

- **GIF Search**: Search for GIFs using Giphy API
- **Infinite Scroll**: Pagination with automatic loading of more results
- **GIF Details**: View detailed information about each GIF
- **Connectivity Handling**: Automatic detection and handling of network connectivity issues
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Responsive Design**: Adaptive UI for different screen sizes and orientations
- **Image Caching**: Efficient image loading with cached network images

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a modular structure:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Screens, Widgets, BLoC/Cubit)   │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│          Domain Layer               │
│      (Repositories, Models)         │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│           Data Layer                │
│    (API Services, Data Sources)     │
└─────────────────────────────────────┘
```

### Key Components:

1. **State Management**: BLoC/Cubit pattern for predictable state management
2. **Dependency Injection**: Injectable + GetIt for loose coupling
3. **Routing**: AutoRoute for type-safe navigation
4. **API Client**: Custom API client with comprehensive error handling
5. **Repository Pattern**: Abstraction layer between data sources and business logic

## 🛠️ Tech Stack

- **Flutter**: 3.32.8
- **State Management**: flutter_bloc (BLoC/Cubit pattern)
- **Dependency Injection**: injectable + get_it
- **Routing**: auto_route
- **Networking**: dio
- **Connectivity**: connectivity_plus
- **Image Loading**: cached_network_image
- **Code Generation**: json_serializable, build_runner
- **Testing**: flutter_test, mocktail
- **Environment Variables**: flutter_dotenv

## 📁 Project Structure

```
lib/
├── app.dart                    # Main app widget
├── main.dart                   # App entry point
├── core/                       # Core functionality
│   ├── api_client/            # API client with error handling
│   ├── common/                # Shared models and widgets
│   ├── connectivity/          # Network connectivity handling
│   ├── di/                    # Dependency injection setup
│   ├── router/                # Navigation and routing
│   └── ui_kit/                # Reusable UI components
└── modules/                    # Feature modules
    ├── giphy_list/           # GIF list/search feature
    │   ├── cubit/            # State management
    │   ├── data/             # Data layer (models, repositories, services)
    │   └── screens/          # UI screens
    └── giphy_detail/         # GIF detail feature
        ├── cubit/
        ├── data/
        └── screens/
```

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK 3.32.8 or compatible
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Giphy API Key ([Get one here](https://developers.giphy.com/))

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd giphy_app-1
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Create environment file**
   ```bash
   cp .env.example .env
   ```

4. **Configure environment variables**
   Edit `.env` file and add your Giphy API key:
   ```
   BASE_URL=https://api.giphy.com/
   API_KEY=your_giphy_api_key_here
   ENVIRONMENT=dev
   ```

5. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## ▶️ Running the App

### Development Mode
```bash
flutter run
```

### Run on Specific Device
```bash
flutter devices                    # List available devices
flutter run -d <device-id>         # Run on specific device
```

### Build for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Test Structure
- **Unit Tests**: Test individual components (Cubits, Repositories)
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows

Test files are located in the `test/` directory, mirroring the `lib/` structure.

## 🔧 Code Generation

This project uses code generation for:
- JSON serialization (`json_serializable`)
- Dependency injection (`injectable`)
- Routing (`auto_route`)

### Generate Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch Mode (for development)
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 💡 Key Design Decisions

### 1. Clean Architecture
- Separation of concerns with clear layer boundaries
- Business logic independent of UI and data sources
- Easy to test and maintain

### 2. BLoC Pattern
- Predictable state management
- Testable business logic
- Reactive UI updates

### 3. Repository Pattern
- Abstraction over data sources
- Easy to swap implementations (e.g., API to local cache)
- Centralized data access logic

### 4. Custom API Client
- Centralized error handling
- Consistent error types across the app
- Easy to add interceptors (logging, authentication, etc.)

### 5. Dependency Injection
- Loose coupling between components
- Easy to mock for testing
- Centralized dependency management

### 6. Error Handling Strategy
- Custom exception hierarchy
- User-friendly error messages
- Proper error propagation through layers

## 📝 Environment Variables

Required environment variables (in `.env` file):

- `BASE_URL`: Giphy API base URL (default: `https://api.giphy.com/`)
- `API_KEY`: Your Giphy API key
- `ENVIRONMENT`: Environment name (dev, staging, prod)

## 🔍 Code Quality

- **Linting**: Configured with `flutter_lints`
- **Analysis**: Run `flutter analyze` to check code quality
- **Formatting**: Use `dart format .` to format code

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Giphy API Documentation](https://developers.giphy.com/docs/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 👤 Author

Prepared for technical interview demonstration.

## 📄 License

This project is for interview purposes.
