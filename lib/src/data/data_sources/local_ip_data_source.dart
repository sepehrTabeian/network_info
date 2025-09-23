import 'dart:io';
import 'package:network_info/src/domain/exceptions/network_info_exception.dart';

/// Data source for retrieving local IP address
/// Single Responsibility: Only handles local IP retrieval
abstract interface class ILocalIpDataSource {
  Future<String?> getLocalIp();
}

class LocalIpDataSource implements ILocalIpDataSource {
  @override
  Future<String?> getLocalIp() async {
    try {
      // Get all network interfaces
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );

      // Prefer non-loopback addresses
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
            // Prefer certain interface types (Wi-Fi, Ethernet)
            if (_isPreferredInterface(interface.name)) {
              return addr.address;
            }
          }
        }
      }

      // Fallback: return any non-loopback IPv4 address
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
            return addr.address;
          }
        }
      }

      return null;
    } catch (e) {
      throw LocalIpException(
        'Failed to retrieve local IP address',
        originalError: e,
      );
    }
  }

  /// Checks if the interface is a preferred type (Wi-Fi, Ethernet)
  bool _isPreferredInterface(String interfaceName) {
    final lowerName = interfaceName.toLowerCase();
    return lowerName.contains('wlan') || // Wi-Fi on Android/Linux
        lowerName.contains('en') || // Ethernet/Wi-Fi on iOS/macOS
        lowerName.contains('eth') || // Ethernet on Linux
        lowerName.contains('wi-fi'); // Wi-Fi on Windows
  }
}
