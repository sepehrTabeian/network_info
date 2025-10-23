# Network Info Package Architecture

## Overview

Version 2.0.0 introduces a **simplified, unified interface** for the network_info package. This design hides the complexity of dependency injection, repository management, and data source coordination behind a clean, easy-to-use API.

## Design Philosophy

The architecture provides a simplified interface to a complex subsystem:

- **Simplifies** complex systems by providing a unified interface
- **Hides** internal complexity from the user
- **Decouples** client code from subsystem details
- **Provides** a higher-level interface that makes subsystems easier to use

## Why We Implemented It

### Before (v1.x) - Complex Setup

```dart
import 'package:get_it/get_it.dart';
import 'package:network_info/network_info.dart';

void main() {
  // Step 1: Manual DI setup
  NetworkInfoDI.setupNetworkInfoDI();
  
  runApp(MyApp());
}

// Step 2: Get repository from DI container
final repo = GetIt.instance<INetworkInfoRepository>();

// Step 3: Use repository
final publicIp = await repo.getPublicIp();
```

**Problems:**
- ❌ Requires understanding of dependency injection
- ❌ Requires knowledge of GetIt
- ❌ Requires manual initialization
- ❌ Exposes internal architecture to users
- ❌ More boilerplate code
- ❌ Steeper learning curve

### After (v2.x) - Simple Facade

```dart
import 'package:network_info/network_info.dart';

// Just use it - auto-initializes!
final publicIp = await NetworkInfo.getPublicIp();
```

**Benefits:**
- ✅ No DI knowledge required
- ✅ No manual setup needed
- ✅ Auto-initialization
- ✅ Simple, self-documenting API
- ✅ Minimal boilerplate
- ✅ Easy to learn and use

## Architecture

### Complete Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     CLIENT CODE                              │
│                  (User's Application)                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ Simple API
                         │
┌────────────────────────▼────────────────────────────────────┐
│                  FACADE LAYER                                │
│              NetworkInfo                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Static Methods:                                     │   │
│  │  + getPublicIp()                                     │   │
│  │  + getLocalIp()                                      │   │
│  │  + isConnected()                                     │   │
│  │  + getNetworkInfo()                                  │   │
│  │  + initialize(config)                                │   │
│  │  + reset()                                           │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │ Hides Complexity
                         │
┌────────────────────────▼────────────────────────────────────┐
│                DEPENDENCY INJECTION LAYER                    │
│                  NetworkInfoDI                               │
│  - Manages GetIt container                                  │
│  - Registers dependencies                                   │
│  - Provides lifecycle management                            │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                  DOMAIN LAYER                                │
│           INetworkInfoRepository (Interface)                 │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  + getPublicIp(): Future<String?>                    │   │
│  │  + getLocalIp(): Future<String?>                     │   │
│  │  + isConnected(): Future<bool>                       │   │
│  │  + getNetworkInfo(): Future<NetworkInfoModel>        │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   DATA LAYER                                 │
│          NetworkInfoRepositoryImpl                           │
│  - Coordinates data sources                                 │
│  - Handles error gracefully                                 │
└────────────────────────┬────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
┌────────▼───────┐ ┌────▼──────┐ ┌─────▼──────────┐
│ PublicIpData   │ │ LocalIp   │ │ Connectivity   │
│ Source         │ │ DataSource│ │ DataSource     │
└────────────────┘ └───────────┘ └────────────────┘
```

### Layer Responsibilities

#### 1. Facade Layer (NEW in v2.0)
**File:** `lib/src/facade/network_info_facade.dart`

**Responsibilities:**
- Provide simple, static API
- Auto-initialize dependencies
- Hide internal complexity
- Offer both static and instance methods

**Key Methods:**
```dart
class NetworkInfo {
  // Simple static methods
  static Future<String?> getPublicIp()
  static Future<String?> getLocalIp()
  static Future<bool> isConnected()
  static Future<NetworkInfoModel> getNetworkInfo()
  
  // Configuration
  static void initialize({NetworkInfoConfig? config})
  static void reset()
  
  // Instance access (for advanced users)
  static NetworkInfo get instance
}
```

#### 2. Domain Layer (Unchanged)
**Files:** `lib/src/domain/`

**Responsibilities:**
- Define business logic interfaces
- Define data models
- Define exceptions

#### 3. Data Layer (Unchanged)
**Files:** `lib/src/data/`

**Responsibilities:**
- Implement repositories
- Implement data sources
- Handle API calls and network interfaces

#### 4. DI Layer (Unchanged)
**Files:** `lib/src/di/`

**Responsibilities:**
- Manage dependency injection
- Register services in GetIt container

## Usage Patterns

### Pattern 1: Simple Static Usage (Recommended)

```dart
import 'package:network_info/network_info.dart';

// No setup needed - just use it!
final publicIp = await NetworkInfo.getPublicIp();
final localIp = await NetworkInfo.getLocalIp();
final isConnected = await NetworkInfo.isConnected();
```

**Use when:** You want the simplest possible API

### Pattern 2: Batch Retrieval

```dart
// Get all info at once (more efficient - uses parallel requests)
final info = await NetworkInfo.getNetworkInfo();

print('Public IP: ${info.publicIp ?? "N/A"}');
print('Local IP: ${info.localIp ?? "N/A"}');
print('Connected: ${info.isConnected}');
```

**Use when:** You need multiple pieces of information

### Pattern 3: Custom Configuration

```dart
// Initialize with custom config before first use
NetworkInfo.initialize(
  config: NetworkInfoConfig(
    timeout: Duration(seconds: 10),
    retryCount: 5,
    publicIpServices: [
      'https://api.ipify.org?format=text',
      'https://icanhazip.com',
    ],
  ),
);

// Then use normally
final publicIp = await NetworkInfo.getPublicIp();
```

**Use when:** You need custom timeout, retries, or specific services

### Pattern 4: Instance Usage (Advanced)

```dart
// Get singleton instance
final facade = NetworkInfo.instance;

// Use instance methods
final publicIp = await facade.getPublicIpInstance();
final localIp = await facade.getLocalIpInstance();
```

**Use when:** You prefer instance-based API or need to pass facade as dependency

### Pattern 5: Direct DI Access (Advanced)

```dart
// For advanced users who need full control
NetworkInfoDI.setupNetworkInfoDI(
  customHttpClient: myCustomClient,
  config: myConfig,
);

final repo = GetIt.instance<INetworkInfoRepository>();
final publicIp = await repo.getPublicIp();
```

**Use when:** You need direct access to repositories or custom HTTP clients

## Testing with Facade

### Testing Your Code

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:network_info/network_info.dart';

void main() {
  setUp(() {
    // Reset before each test
    NetworkInfo.reset();
  });

  test('should get network info', () async {
    final info = await NetworkInfo.getNetworkInfo();
    
    expect(info, isA<NetworkInfoModel>());
    expect(info.isConnected, isA<bool>());
  });
}
```

### Mocking for Advanced Tests

If you need to mock the repository for testing your own code:

```dart
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:network_info/network_info.dart';

class MockRepository extends Mock implements INetworkInfoRepository {}

void main() {
  test('my code with mocked repository', () async {
    // Setup mock
    final mockRepo = MockRepository();
    when(mockRepo.getPublicIp()).thenAnswer((_) async => '1.2.3.4');
    
    // Register mock
    NetworkInfoDI.reset();
    GetIt.instance.registerSingleton<INetworkInfoRepository>(mockRepo);
    
    // Now Facade will use your mock
    final ip = await NetworkInfo.getPublicIp();
    expect(ip, '1.2.3.4');
  });
}
```

## Design Benefits

### 1. Separation of Concerns
- **Facade** handles user interaction
- **Repository** handles business logic
- **Data Sources** handle data retrieval

### 2. Single Responsibility Principle
Each class has one clear job:
- `NetworkInfo`: Simple API
- `NetworkInfoDI`: Dependency management
- `NetworkInfoRepositoryImpl`: Business logic coordination
- Data sources: Specific data retrieval

### 3. Open/Closed Principle
- Facade is open for extension (add new methods)
- But closed for modification (internal implementation stays stable)

### 4. Dependency Inversion
- High-level Facade depends on abstraction (INetworkInfoRepository)
- Not on concrete implementations

### 5. Interface Segregation
- Simple facade interface for common use
- Advanced interfaces available when needed

## Migration Guide

### Migrating from v1.x to v2.x

**Old code (v1.x):**
```dart
import 'package:get_it/get_it.dart';
import 'package:network_info/network_info.dart';

void main() {
  NetworkInfoDI.setupNetworkInfoDI();
  runApp(MyApp());
}

// In your widget
final repo = GetIt.instance<INetworkInfoRepository>();
final publicIp = await repo.getPublicIp();
```

**New code (v2.x):**
```dart
import 'package:network_info/network_info.dart';

void main() {
  // No setup needed!
  runApp(MyApp());
}

// In your widget
final publicIp = await NetworkInfo.getPublicIp();
```

### Backward Compatibility

**All v1.x code continues to work!** No breaking changes.

```dart
// ✅ Still works
NetworkInfoDI.setupNetworkInfoDI();
final repo = GetIt.instance<INetworkInfoRepository>();

// ✅ New way (recommended)
final publicIp = await NetworkInfo.getPublicIp();
```

## Performance Considerations

### Auto-initialization Overhead
- First call initializes GetIt (minimal overhead, ~1ms)
- Subsequent calls have zero overhead
- Lazy initialization - only happens when needed

### Parallel Requests
```dart
// ❌ Sequential (slower)
final publicIp = await NetworkInfo.getPublicIp();
final localIp = await NetworkInfo.getLocalIp();
final connected = await NetworkInfo.isConnected();

// ✅ Parallel (faster - recommended)
final info = await NetworkInfo.getNetworkInfo();
// Internally uses Future.wait for parallel execution
```

## Summary

The simplified architecture in v2.0.0:

- ✅ **Simplifies** the API from 3 steps to 1 line
- ✅ **Hides** DI complexity from users
- ✅ **Maintains** backward compatibility
- ✅ **Improves** developer experience
- ✅ **Reduces** boilerplate code
- ✅ **Preserves** all advanced features for power users
- ✅ **Follows** SOLID principles
- ✅ **Enhances** testability

**Result:** A more accessible package that's easier to use while maintaining architectural excellence for advanced scenarios.
