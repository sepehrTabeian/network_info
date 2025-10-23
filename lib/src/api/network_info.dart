import 'package:get_it/get_it.dart';
import 'package:network_info/src/data/config/network_info_config.dart';
import 'package:network_info/src/di/network_info_di.dart';
import 'package:network_info/src/domain/models/network_info_model.dart';
import 'package:network_info/src/domain/repository/i_network_info_repository.dart';

/// Main facade for Network Info Package
///
/// This class provides a simple, static API for accessing network information
/// without needing to manually manage dependency injection.
///
/// ## Basic Usage
///
/// ```dart
/// // Get all network info at once
/// final info = await NetworkInfo.getNetworkInfo();
/// print('Public IP: ${info.publicIp}');
/// print('Local IP: ${info.localIp}');
/// print('Connected: ${info.isConnected}');
///
/// // Or get specific information
/// final publicIp = await NetworkInfo.getPublicIp();
/// final localIp = await NetworkInfo.getLocalIp();
/// final isConnected = await NetworkInfo.isConnected();
/// ```
///
/// ## Custom Configuration (Optional)
///
/// You can customize the package behavior by calling initialize:
///
/// ```dart
/// NetworkInfo.initialize(
///   config: NetworkInfoConfig(
///     timeout: Duration(seconds: 10),
///     retryCount: 5,
///   ),
/// );
/// ```
class NetworkInfo {
  // Private constructor to prevent instantiation
  NetworkInfo._();

  /// Initialize the Network Info package with custom configuration
  ///
  /// This is optional - the package will auto-initialize with default settings
  /// if you don't call this method.
  ///
  /// [config] - Optional configuration for network operations
  static void initialize({
    NetworkInfoConfig? config,
  }) {
    NetworkInfoDI.setupNetworkInfoDI(config: config);
  }

  /// Internal method to ensure DI is initialized before use
  static void _ensureInitialized() {
    if (!NetworkInfoDI.isInitialized) {
      NetworkInfoDI.setupNetworkInfoDI();
    }
  }

  /// Gets the repository instance from DI
  static INetworkInfoRepository get _repository {
    _ensureInitialized();
    return GetIt.instance<INetworkInfoRepository>();
  }

  /// Retrieves the public IP address (visible on the internet)
  ///
  /// Returns null if offline or the service is unavailable.
  ///
  /// Example:
  /// ```dart
  /// final publicIp = await NetworkInfo.getPublicIp();
  /// if (publicIp != null) {
  ///   print('Your public IP is: $publicIp');
  /// }
  /// ```
  static Future<String?> getPublicIp() async {
    return _repository.getPublicIp();
  }

  /// Retrieves the local IP address (LAN/Wi-Fi)
  ///
  /// Returns null if not connected to any network.
  ///
  /// Example:
  /// ```dart
  /// final localIp = await NetworkInfo.getLocalIp();
  /// if (localIp != null) {
  ///   print('Your local IP is: $localIp');
  /// }
  /// ```
  static Future<String?> getLocalIp() async {
    return _repository.getLocalIp();
  }

  /// Checks if the device is connected to any network
  ///
  /// Returns true if connected to Wi-Fi, cellular, ethernet, etc.
  ///
  /// Example:
  /// ```dart
  /// final connected = await NetworkInfo.isConnected();
  /// if (connected) {
  ///   print('Device is online');
  /// } else {
  ///   print('Device is offline');
  /// }
  /// ```
  static Future<bool> isConnected() async {
    return _repository.isConnected();
  }

  /// Retrieves complete network information
  ///
  /// This is the most convenient method as it fetches all network information
  /// in a single call.
  ///
  /// Returns a [NetworkInfoModel] containing public IP, local IP, and connection status.
  ///
  /// Example:
  /// ```dart
  /// final info = await NetworkInfo.getNetworkInfo();
  /// print('Public IP: ${info.publicIp}');
  /// print('Local IP: ${info.localIp}');
  /// print('Connected: ${info.isConnected}');
  /// ```
  static Future<NetworkInfoModel> getNetworkInfo() async {
    return _repository.getNetworkInfo();
  }

  /// Resets the internal dependency injection container
  ///
  /// This is mainly useful for testing or when you need to completely
  /// reinitialize the package with different settings.
  ///
  /// After calling this, the next call to any NetworkInfo method will
  /// automatically reinitialize with default settings (unless you call
  /// [initialize] again).
  static void reset() {
    NetworkInfoDI.reset();
  }
}
