import 'package:network_info/src/domain/models/network_info_model.dart';

/// Repository interface for network information operations
/// Following Interface Segregation Principle - focused interface
abstract interface class INetworkInfoRepository {
  /// Retrieves the public IP address (visible on the internet)
  /// Returns null if offline or service unavailable
  Future<String?> getPublicIp();

  /// Retrieves the local IP address (LAN/Wi-Fi)
  /// Returns null if not connected to any network
  Future<String?> getLocalIp();

  /// Retrieves complete network information
  Future<NetworkInfoModel> getNetworkInfo();

  /// Checks if device is connected to any network
  Future<bool> isConnected();
}
