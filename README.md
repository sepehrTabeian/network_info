# Network Info Package

A standalone Flutter package for retrieving network information including public and local IP addresses.

**✨ Simple & Clean API!**

## Features

- 🌐 Get public IP address (visible on the internet)
- 🏠 Get local IP address (LAN/Wi-Fi)
- 🔄 Multiple fallback services for reliability
- ⚡ **Auto-initialization** - No manual DI setup required
- 🎯 **Simple unified API** - One-line access to all features
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

## Quick Start (Recommended)

The simplest way to use this package:

```dart
import 'package:network_info/network_info.dart';

// No initialization needed! Auto-initializes on first use

// Get public IP
final publicIp = await NetworkInfo.getPublicIp();
print('Public IP: $publicIp');

// Get local IP
final localIp = await NetworkInfo.getLocalIp();
print('Local IP: $localIp');

// Check connectivity
final isConnected = await NetworkInfo.isConnected();
print('Connected: $isConnected');

// Get all info at once (more efficient)
final info = await NetworkInfo.getNetworkInfo();
print('Public: ${info.publicIp}, Local: ${info.localIp}, Connected: ${info.isConnected}');
```

### With Custom Configuration (Optional)

```dart
import 'package:network_info/network_info.dart';

void main() {
  // Optional: customize before first use
  NetworkInfo.initialize(
    config: NetworkInfoConfig(
      timeout: Duration(seconds: 10),
      retryCount: 5,
    ),
  );
  
  runApp(MyApp());
}
```

## Advanced Usage (Direct DI Access)

For advanced scenarios, you can still access the repository directly:

### 1. Setup Dependency Injection

```dart
import 'package:network_info/network_info.dart';

void main() {
  // Initialize the package
  NetworkInfoDI.setupNetworkInfoDI();
  
  runApp(MyApp());
}
```

### 2. Use Repository Interface

```dart
import 'package:get_it/get_it.dart';
import 'package:network_info/network_info.dart';

final locator = GetIt.instance;

Future<void> getNetworkInfo() async {
  final networkInfo = locator<INetworkInfoRepository>();
  
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

- **Facade Pattern**: Simplified interface hiding system complexity (NetworkInfo)
- **Repository Pattern**: Abstracts data source details
- **Dependency Injection**: For better testability and flexibility
- **Strategy Pattern**: Multiple implementations for different scenarios
- **Singleton Pattern**: Single instance management via GetIt

## Why Use This Package?

This package provides a simplified interface to network information. Benefits include:

- **✅ Simpler API**: One line of code instead of multiple DI setup steps
- **✅ Auto-initialization**: No manual setup required
- **✅ Less boilerplate**: No need to manage GetIt or repository instances
- **✅ Clearer intent**: `NetworkInfo.getPublicIp()` is self-documenting
- **✅ Backward compatible**: Advanced users can still access lower-level APIs
- **✅ Better DX**: Improved developer experience and faster onboarding

**Before (v1.x):**
```dart
NetworkInfoDI.setupNetworkInfoDI();
final repo = GetIt.instance<INetworkInfoRepository>();
final ip = await repo.getPublicIp();
```

**After (v2.x):**
```dart
final ip = await NetworkInfo.getPublicIp();
```

## Comparison with Other Packages

| Feature | This Package | network_info_plus | connectivity_plus |
|---------|--------------|------------------|-------------------|
| Simple unified API | ✅ | ❌ | ❌ |
| Auto-initialization | ✅ | ❌ | ❌ |
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

## More Examples

### Custom Configuration

```dart
// Initialize with custom configuration
NetworkInfo.initialize(
  config: NetworkInfoConfig(
    publicIpServices: [
      'https://api.ipify.org?format=text',
      'https://icanhazip.com',
    ],
    timeout: Duration(seconds: 10),
    retryCount: 5,
  ),
);

// Then use normally
final publicIp = await NetworkInfo.getPublicIp();
```

### Custom HTTP Client (Advanced DI)

```dart
import 'package:http/http.dart' as http;

NetworkInfoDI.setupNetworkInfoDI(
  customHttpClient: http.Client(),
  config: NetworkInfoConfig(
    timeout: Duration(seconds: 10),
  ),
);
```

### Error Handling

Errors are handled gracefully by returning `null` or `false`:

```dart
// Returns null if offline or service unavailable
final publicIp = await NetworkInfo.getPublicIp();
if (publicIp == null) {
  print('Unable to retrieve public IP (offline or service unavailable)');
} else {
  print('Public IP: $publicIp');
}

// Returns false if offline
final isConnected = await NetworkInfo.isConnected();
if (!isConnected) {
  print('Device is offline');
}

// Always returns a valid model (with null IPs if unavailable)
final info = await NetworkInfo.getNetworkInfo();
print('Connected: ${info.isConnected}');
if (info.hasAnyIp) {
  print('Best IP: ${info.bestAvailableIp}');
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



