import 'package:http/http.dart' as http;
import 'package:network_info/src/data/config/network_info_config.dart';
import 'package:network_info/src/domain/exceptions/network_info_exception.dart';

/// Data source for retrieving public IP address
/// Single Responsibility: Only handles public IP retrieval
abstract interface class IPublicIpDataSource {
  Future<String?> getPublicIp();
}

class PublicIpDataSource implements IPublicIpDataSource {
  PublicIpDataSource({
    required http.Client httpClient,
    required NetworkInfoConfig config,
  })  : _httpClient = httpClient,
        _config = config;

  final http.Client _httpClient;
  final NetworkInfoConfig _config;

  @override
  Future<String?> getPublicIp() async {
    // Try each service in order
    for (final serviceUrl in _config.publicIpServices) {
      try {
        final ip = await _fetchFromService(serviceUrl);
        if (ip != null && _isValidIpv4(ip)) {
          return ip;
        }
      } catch (_) {
        // Continue to next service
        continue;
      }
    }

    // All services failed
    return null;
  }

  /// Fetches IP from a specific service with retry logic
  Future<String?> _fetchFromService(String serviceUrl) async {
    for (int attempt = 0; attempt < _config.retryCount; attempt++) {
      try {
        final response = await _httpClient
            .get(Uri.parse(serviceUrl))
            .timeout(_config.timeout);

        if (response.statusCode == 200) {
          final ip = response.body.trim();
          if (ip.isNotEmpty) {
            return ip;
          }
        }
      } catch (e) {
        if (attempt == _config.retryCount - 1) {
          // Last attempt failed
          throw PublicIpException(
            'Failed to fetch public IP from $serviceUrl',
            originalError: e,
          );
        }
        // Wait before retry (exponential backoff)
        await Future.delayed(Duration(milliseconds: 100 * (attempt + 1)));
      }
    }

    return null;
  }

  /// Validates if the string is a valid IPv4 address
  bool _isValidIpv4(String ip) {
    final ipv4Pattern = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipv4Pattern.hasMatch(ip);
  }
}
