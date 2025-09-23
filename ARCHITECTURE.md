# Network Info Package - Architecture

## Overview

This package follows **Clean Architecture** principles with clear separation of concerns and adherence to **SOLID** principles.

## Layer Structure

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

## SOLID Principles Applied

### 1. Single Responsibility Principle (SRP)

Each class has one clear responsibility:

- **PublicIpDataSource**: Only retrieves public IP addresses
- **LocalIpDataSource**: Only retrieves local IP addresses
- **ConnectivityDataSource**: Only checks network connectivity
- **NetworkInfoRepositoryImpl**: Coordinates data sources
- **NetworkInfoModel**: Represents network information data

### 2. Open/Closed Principle (OCP)

- All components use interfaces, making them open for extension
- New data sources can be added without modifying existing code
- Custom implementations can be injected via DI

### 3. Liskov Substitution Principle (LSP)

- All implementations can be substituted with their interfaces
- Mock implementations for testing follow the same contracts
- No implementation breaks the interface contract

### 4. Interface Segregation Principle (ISP)

- **INetworkInfoRepository**: Focused interface with only necessary methods
- **IPublicIpDataSource**: Single method interface
- **ILocalIpDataSource**: Single method interface
- **IConnectivityDataSource**: Minimal connectivity interface

### 5. Dependency Inversion Principle (DIP)

- High-level modules depend on abstractions (interfaces)
- Low-level modules implement abstractions
- All dependencies injected via constructors

## Design Patterns Used

### 1. Repository Pattern

```dart
abstract interface class INetworkInfoRepository {
  Future<String?> getPublicIp();
  Future<String?> getLocalIp();
  Future<NetworkInfoModel> getNetworkInfo();
  Future<bool> isConnected();
}
```

**Benefits:**
- Abstracts data source details
- Easy to test with mocks
- Centralized data access logic

### 2. Dependency Injection Pattern

```dart
class NetworkInfoDI {
  static void setupNetworkInfoDI({
    http.Client? customHttpClient,
    Connectivity? customConnectivity,
    NetworkInfoConfig? config,
  }) {
    // Register dependencies
  }
}
```

**Benefits:**
- Loose coupling
- Easy testing
- Flexible configuration

### 3. Strategy Pattern

Multiple public IP services with fallback:

```dart
class PublicIpDataSource {
  Future<String?> getPublicIp() async {
    for (final serviceUrl in _config.publicIpServices) {
      try {
        final ip = await _fetchFromService(serviceUrl);
        if (ip != null) return ip;
      } catch (_) {
        continue; // Try next service
      }
    }
    return null;
  }
}
```

**Benefits:**
- Reliability through redundancy
- Configurable service list
- Graceful degradation

### 4. Factory Pattern

Configuration with defaults:

```dart
class NetworkInfoConfig {
  const NetworkInfoConfig({
    this.publicIpServices = defaultPublicIpServices,
    this.timeout = const Duration(seconds: 5),
    this.retryCount = 3,
  });
}
```

**Benefits:**
- Sensible defaults
- Easy customization
- Type-safe configuration

### 5. Singleton Pattern (via GetIt)

```dart
getIt.registerLazySingleton<INetworkInfoRepository>(
  () => NetworkInfoRepositoryImpl(...),
);
```

**Benefits:**
- Single instance per app
- Efficient resource usage
- Consistent state

## Data Flow

```
User Code
    ↓
INetworkInfoRepository (Interface)
    ↓
NetworkInfoRepositoryImpl
    ↓
┌─────────────┬──────────────┬────────────────┐
↓             ↓              ↓                ↓
PublicIp   LocalIp    Connectivity      Model
DataSource DataSource  DataSource      Assembly
    ↓             ↓              ↓                ↓
HTTP Client  Network     Connectivity+      NetworkInfoModel
             Interface
```

## Error Handling Strategy

### Graceful Degradation

```dart
@override
Future<String?> getPublicIp() async {
  try {
    return await _publicIpDataSource.getPublicIp();
  } catch (_) {
    return null; // Graceful degradation
  }
}
```

**Philosophy:**
- Never crash the app
- Return null for unavailable data
- Let the UI decide how to handle missing data

### Retry Logic

```dart
for (int attempt = 0; attempt < _config.retryCount; attempt++) {
  try {
    final response = await _httpClient.get(uri).timeout(_config.timeout);
    if (response.statusCode == 200) return response.body.trim();
  } catch (e) {
    if (attempt == _config.retryCount - 1) throw;
    await Future.delayed(Duration(milliseconds: 100 * (attempt + 1)));
  }
}
```

**Features:**
- Exponential backoff
- Configurable retry count
- Per-service timeout

## Testing Strategy

### Unit Tests

- **Models**: Test serialization, equality, copyWith
- **Data Sources**: Mock HTTP client and network interfaces
- **Repository**: Mock all data sources
- **DI**: Test registration and lifecycle

### Integration Tests

- Test complete flow from repository to data sources
- Test with real network conditions (optional)

### Mock Generation

```dart
@GenerateMocks([http.Client, Connectivity])
```

## Performance Considerations

### 1. Parallel Fetching

```dart
final results = await Future.wait([
  getPublicIp(),
  getLocalIp(),
  isConnected(),
]);
```

### 2. Lazy Singletons

```dart
getIt.registerLazySingleton<INetworkInfoRepository>(
  () => NetworkInfoRepositoryImpl(...),
);
```

### 3. Caching (Future Enhancement)

Could add caching layer for public IP:

```dart
class CachedPublicIpDataSource implements IPublicIpDataSource {
  String? _cachedIp;
  DateTime? _cacheTime;
  
  @override
  Future<String?> getPublicIp() async {
    if (_isCacheValid()) return _cachedIp;
    _cachedIp = await _delegate.getPublicIp();
    _cacheTime = DateTime.now();
    return _cachedIp;
  }
}
```

## Extensibility

### Adding New IP Service

```dart
NetworkInfoDI.setupNetworkInfoDI(
  config: NetworkInfoConfig(
    publicIpServices: [
      'https://api.ipify.org?format=text',
      'https://my-custom-service.com/ip',
    ],
  ),
);
```

### Custom Data Source

```dart
class CustomPublicIpDataSource implements IPublicIpDataSource {
  @override
  Future<String?> getPublicIp() async {
    // Custom implementation
  }
}

// Register in DI
getIt.registerLazySingleton<IPublicIpDataSource>(
  () => CustomPublicIpDataSource(),
);
```

## Best Practices Followed

1. ✅ **Immutable Models**: All models are immutable with `const` constructors
2. ✅ **Interface-First**: All public APIs use interfaces
3. ✅ **Null Safety**: Full null safety support
4. ✅ **Error Handling**: Comprehensive exception hierarchy
5. ✅ **Documentation**: All public APIs documented
6. ✅ **Testing**: High test coverage
7. ✅ **Type Safety**: Strong typing throughout
8. ✅ **Separation of Concerns**: Clear layer boundaries

## Comparison with Other Packages

| Feature | This Package | network_info_plus | connectivity_plus |
|---------|-------------|-------------------|-------------------|
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

1. **IPv6 Support**: Add IPv6 address retrieval
2. **Caching**: Add configurable caching for public IP
3. **Network Speed**: Add network speed testing
4. **VPN Detection**: Detect if VPN is active
5. **Proxy Detection**: Detect proxy usage
6. **Network Type**: Detailed network type (2G/3G/4G/5G)

---

## Author

**Sepehr Tabeian**

## License

MIT License - Copyright (c) 2025 Sepehr Tabeian

See [LICENSE](LICENSE) file for details.
