# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
