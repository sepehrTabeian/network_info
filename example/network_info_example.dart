import 'package:get_it/get_it.dart';
import 'package:network_info/network_info.dart';

/// Example demonstrating all NetworkInfo features
/// 
/// This example shows different ways to use NetworkInfo
void main() async {
  print('=== Network Info Facade Example ===\n');

  // ==================== Example 1: Simple Static Usage ====================
  print('1. Simple Static Usage:');
  await simpleUsage();

  print('\n');

  // ==================== Example 2: Get All Info at Once ====================
  print('2. Get All Info at Once:');
  await getAllInfo();

  print('\n');

  // ==================== Example 3: Custom Configuration ====================
  print('3. Custom Configuration:');
  await customConfiguration();

  print('\n');

  // ==================== Example 4: Advanced Repository Usage ====================
  print('4. Advanced Repository Usage:');
  await advancedRepositoryUsage();

  print('\n');

  // ==================== Example 5: Error Handling ====================
  print('5. Error Handling:');
  await errorHandling();
}

/// Simple static usage - recommended approach
Future<void> simpleUsage() async {
  // No initialization needed - Facade auto-initializes!
  
  final publicIp = await NetworkInfo.getPublicIp();
  print('Public IP: ${publicIp ?? "Not available"}');

  final localIp = await NetworkInfo.getLocalIp();
  print('Local IP: ${localIp ?? "Not available"}');

  final isConnected = await NetworkInfo.isConnected();
  print('Connected: $isConnected');
}

/// Get all network info at once (more efficient)
Future<void> getAllInfo() async {
  // Fetches all info in parallel for better performance
  final info = await NetworkInfo.getNetworkInfo();

  print('Public IP: ${info.publicIp ?? "N/A"}');
  print('Local IP: ${info.localIp ?? "N/A"}');
  print('Connected: ${info.isConnected}');

  // Use helper getters
  if (info.hasAnyIp) {
    print('Best available IP: ${info.bestAvailableIp}');
  } else {
    print('No IP addresses available');
  }
}

/// Custom configuration example
Future<void> customConfiguration() async {
  // Reset to demonstrate re-initialization
  NetworkInfo.reset();

  // Initialize with custom config
  NetworkInfo.initialize(
    config: NetworkInfoConfig(
      timeout: Duration(seconds: 10), // Longer timeout
      retryCount: 5, // More retries
      publicIpServices: [
        // Custom order of services
        'https://api.ipify.org?format=text',
        'https://icanhazip.com',
      ],
    ),
  );

  final publicIp = await NetworkInfo.getPublicIp();
  print('Public IP (with custom config): ${publicIp ?? "Not available"}');
}

/// Advanced repository usage
Future<void> advancedRepositoryUsage() async {
  // For advanced use cases, you can access the repository directly
  // This gives you more control but requires understanding DI
  
  // NetworkInfo handles initialization automatically
  // You can access DI and repository if needed
  NetworkInfoDI.setupNetworkInfoDI();
  
  // Access repository directly from GetIt
  final repository = GetIt.instance<INetworkInfoRepository>();
  
  final publicIp = await repository.getPublicIp();
  final localIp = await repository.getLocalIp();
  final isConnected = await repository.isConnected();

  print('Public IP (via repository): ${publicIp ?? "N/A"}');
  print('Local IP (via repository): ${localIp ?? "N/A"}');
  print('Connected (via repository): $isConnected');
}

/// Error handling example
Future<void> errorHandling() async {
  try {
    final info = await NetworkInfo.getNetworkInfo();
    print('Successfully retrieved network info');
    print('Public IP: ${info.publicIp ?? "N/A"}');
  } catch (e) {
    print('Error getting network info: $e');
    // Facade handles errors gracefully - returns null or false
    // Errors are only thrown if you directly use repositories
  }

  // Individual methods return null/false on error (graceful degradation)
  final publicIp = await NetworkInfo.getPublicIp();
  if (publicIp == null) {
    print('Could not get public IP (offline or service unavailable)');
  }

  final isConnected = await NetworkInfo.isConnected();
  if (!isConnected) {
    print('Device is offline');
  }
}
