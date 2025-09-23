# Network Info Package

A standalone Flutter package for retrieving network information including public and local IP addresses.

## Features

- 🌐 Get public IP address (visible on the internet)
- 🏠 Get local IP address (LAN/Wi-Fi)
- 🔄 Multiple fallback services for reliability
- 🧪 Fully tested with 100+ test cases
- 🏗️ Clean Architecture with SOLID principles
- 💉 Dependency injection support with GetIt
- 🎯 Type-safe with strong typing
- 📦 Zero dependencies on other custom packages

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  network_info:
    path: packages/network_info
```

## Quick Start

### 1. Setup Dependency Injection

```dart
import 'package:network_info/network_info.dart';

void main() {
  // Initialize the package
  NetworkInfoDI.setupNetworkInfoDI();
  
  runApp(MyApp());
}
```

### 2. Use in Your Code

```dart
import 'package:get_it/get_it.dart';
import 'package:network_info/network_info.dart';

final locator = GetIt.instance;

Future<void> getNetworkInfo() async {
  final networkInfo = locator<INetworkInfo>();
  
  // Get public IP
  final publicIp = await networkInfo.getPublicIp();
  print('Public IP: $publicIp');
  
  // Get local IP
  final localIp = await networkInfo.getLocalIp();
  print('Local IP: $localIp');
  
  // Get network info model
  final info = await networkInfo.getNetworkInfo();
  print('Public: ${info.publicIp}, Local: ${info.localIp}');
}
```

## Architecture

This package follows Clean Architecture principles:

```
lib/
├── src/
│   ├── domain/              # Business logic layer
│   │   ├── models/
│   │   │   └── network_info_model.dart
│   │   └── repository/
│   │       └── i_network_info_repository.dart
│   │
│   ├── data/                # Data layer
│   │   ├── data_sources/
│   │   │   ├── local_ip_data_source.dart
│   │   │   └── public_ip_data_source.dart
│   │   └── repository/
│   │       └── network_info_repository_impl.dart
│   │
│   └── di/                  # Dependency injection
│       └── network_info_di.dart
│
└── network_info.dart        # Public API
```

## Advanced Usage

### Custom HTTP Client

```dart
import 'package:http/http.dart' as http;

NetworkInfoDI.setupNetworkInfoDI(
  customHttpClient: http.Client(),
);
```

### Custom Configuration

```dart
NetworkInfoDI.setupNetworkInfoDI(
  config: NetworkInfoConfig(
    publicIpServices: [
      'https://api.ipify.org?format=text',
      'https://icanhazip.com',
    ],
    timeout: Duration(seconds: 10),
  ),
);
```

### Error Handling

```dart
try {
  final publicIp = await networkInfo.getPublicIp();
  if (publicIp == null) {
    print('Unable to retrieve public IP (offline or service unavailable)');
  }
} on NetworkInfoException catch (e) {
  print('Error: ${e.message}');
}
```

## Testing

The package includes comprehensive tests:

```bash
# Run all tests
cd packages/network_info
flutter test

# Run with coverage
flutter test --coverage

# Generate mocks
dart run build_runner build
```

## SOLID Principles

- **Single Responsibility**: Each class has one clear purpose
- **Open/Closed**: Extensible through interfaces
- **Liskov Substitution**: All implementations are substitutable
- **Interface Segregation**: Small, focused interfaces
- **Dependency Inversion**: Depends on abstractions, not concretions

## Author

**Sepehr Tabeian**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Sepehr Tabeian



