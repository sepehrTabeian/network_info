import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info/src/domain/exceptions/network_info_exception.dart';

/// Data source for checking network connectivity
/// Single Responsibility: Only handles connectivity checks
abstract interface class IConnectivityDataSource {
  Future<bool> isConnected();
  Stream<bool> get connectivityStream;
}

class ConnectivityDataSource implements IConnectivityDataSource {
  ConnectivityDataSource({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _isConnectedResult(result);
    } catch (e) {
      throw ConnectivityException(
        'Failed to check connectivity',
        originalError: e,
      );
    }
  }

  @override
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map(_isConnectedResult);
  }

  /// Checks if connectivity result indicates connection
  bool _isConnectedResult(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
  }
}
