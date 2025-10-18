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

This package follows Clean Architecture and SOLID principles with clear separation of concerns:

```
lib/
├── src/
│   ├── domain/              # Business logic layer (pure Dart)
│   │   ├── models/
│   │   │   └── network_info_model.dart
│   │   ├── repository/
│   │   │   └── i_network_info_repository.dart
│   │   └── exceptions/
│   │       └── network_info_exception.dart
│   │
│   ├── data/                # Data layer (implementation)
│   │   ├── config/
│   │   │   └── network_info_config.dart
│   │   ├── data_sources/
│   │   │   ├── public_ip_data_source.dart
│   │   │   ├── local_ip_data_source.dart
│   │   │   └── connectivity_data_source.dart
│   │   └── repository/
│   │       └── network_info_repository_impl.dart
│   │
│   └── di/                  # Dependency injection
│       └── network_info_di.dart
│
└── network_info.dart        # Public API
```

### SOLID Principles Applied

- **Single Responsibility**: Each class has one clear responsibility
- **Open/Closed**: Easy to extend without modifying existing code
- **Liskov Substitution**: All implementations can be substituted with their interfaces
- **Interface Segregation**: Focused interfaces with only necessary methods
- **Dependency Inversion**: High-level modules depend on abstractions

### Design Patterns Used

- **Repository Pattern**: Abstracts data source details
- **Dependency Injection**: For better testability and flexibility
- **Strategy Pattern**: Multiple implementations for different scenarios

## Comparison with Other Packages

| Feature | This Package | network_info_plus | connectivity_plus |
|---------|--------------|------------------|-------------------|
| Public IP | ✅ Multiple services | ❌ | ❌ |
| Local IP | ✅ | ✅ | ❌ |
| Connectivity | ✅ | ❌ | ✅ |
| Clean Architecture | ✅ | ❌ | ❌ |
| DI Support | ✅ GetIt | ❌ | ❌ |
| Testability | ✅ Full mocking | ⚠️ Limited | ⚠️ Limited |
| SOLID Principles | ✅ | ❌ | ❌ |
| Retry Logic | ✅ Configurable | ❌ | ❌ |
| Fallback Services | ✅ Multiple | ❌ | ❌ |

## Future Enhancements

- IPv6 Support: Add IPv6 address retrieval
- Caching: Add configurable caching for public IP
- Network Speed: Add network speed testing
- VPN Detection: Detect if VPN is active
- Proxy Detection: Detect proxy usage
- Network Type: Detailed network type (2G/3G/4G/5G)

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



