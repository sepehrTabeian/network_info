# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-10-23

### Added - Simplified API
- **NetworkInfo**: New simplified API with clean interface
  - Static methods for simple, direct access: `NetworkInfo.getPublicIp()`
  - Instance methods for advanced scenarios
  - Automatic initialization - no manual DI setup required
  - Hides internal complexity (GetIt, repositories, data sources)
  - Custom configuration support
  
### Changed
- **Primary API**: `NetworkInfo` is now the recommended way to use the package
- **Documentation**: Updated with simplified API examples
- **Examples**: Refactored to demonstrate simplified API
  - `example/main.dart`: Updated to use NetworkInfo
  - `example/network_info_example.dart`: Comprehensive examples
  
### Enhanced
- **Better Developer Experience**:
  - No manual DI initialization needed (auto-initializes)
  - Simpler API: `NetworkInfo.getPublicIp()` vs `GetIt.instance<INetworkInfoRepository>()`
  - Less boilerplate code
  - Clearer intent and usage
  
### Maintained
- **Backward Compatibility**: All existing APIs remain available
  - `NetworkInfoDI` still works for manual DI setup
  - `INetworkInfoRepository` still accessible for advanced use
  - All data sources remain unchanged
  - No breaking changes to existing code

### Testing
- Added comprehensive tests for simplified API
- 100% test coverage for new NetworkInfo implementation
- All existing tests remain passing

### Design Patterns
- **Facade Pattern**: Simplified interface hiding system complexity
- Repository Pattern (maintained)
- Dependency Injection Pattern (maintained)
- Strategy Pattern (maintained)
- Singleton Pattern (maintained)

### Migration Guide
**Old Way (still works):**
```dart
NetworkInfoDI.setupNetworkInfoDI();
final repo = GetIt.instance<INetworkInfoRepository>();
final publicIp = await repo.getPublicIp();
```

**New Way (recommended):**
```dart
// No setup needed!
final publicIp = await NetworkInfo.getPublicIp();
```

## [1.0.2] - 2025-10-23

### Fixed
- Fixed an issue with the library directive and exports in `network_info.dart`
- Removed direct dependency on `network_info_di.dart` from the main library file

## [1.0.1] - 2025-01-24

### Changed
- Updated GitHub repository URLs
- Enhanced documentation with comparison table
- Improved README structure and content

## [1.0.0] - 2025-01-23

### Added
- Initial release of network_info package by Sepehr Tabeian
- Public IP address retrieval with multiple fallback services
- Local IP address retrieval (LAN/Wi-Fi)
- Network connectivity checking
- Clean Architecture implementation
- SOLID principles adherence
- Comprehensive test suite (100+ tests)
- Dependency injection support with GetIt
- Configurable timeout and retry logic
- Graceful error handling and degradation
- Full null safety support
- Example application
- Comprehensive documentation

### Features
- **PublicIpDataSource**: Retrieves public IP with fallback services
- **LocalIpDataSource**: Retrieves local network IP
- **ConnectivityDataSource**: Checks network connectivity status
- **NetworkInfoRepository**: Unified interface for all network info
- **NetworkInfoModel**: Immutable model for network information
- **NetworkInfoConfig**: Configurable settings
- **NetworkInfoDI**: Dependency injection setup

### Design Patterns
- Repository Pattern
- Dependency Injection Pattern
- Strategy Pattern (multiple IP services)
- Factory Pattern (configuration)
- Singleton Pattern (via GetIt)

### Testing
- Unit tests for all components
- Mock-based testing with mockito
- Integration tests
- 100+ test cases
- High code coverage

### Documentation
- README with quick start guide
- ARCHITECTURE.md with detailed design
- Example application
- Inline code documentation
- CHANGELOG
