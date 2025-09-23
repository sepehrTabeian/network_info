import 'package:network_info/src/data/data_sources/connectivity_data_source.dart';
import 'package:network_info/src/data/data_sources/local_ip_data_source.dart';
import 'package:network_info/src/data/data_sources/public_ip_data_source.dart';
import 'package:network_info/src/domain/models/network_info_model.dart';
import 'package:network_info/src/domain/repository/i_network_info_repository.dart';

/// Implementation of network info repository
/// Single Responsibility: Coordinates data sources to provide network information
/// Dependency Inversion: Depends on abstractions (interfaces), not concrete classes
class NetworkInfoRepositoryImpl implements INetworkInfoRepository {
  NetworkInfoRepositoryImpl({
    required IPublicIpDataSource publicIpDataSource,
    required ILocalIpDataSource localIpDataSource,
    required IConnectivityDataSource connectivityDataSource,
  })  : _publicIpDataSource = publicIpDataSource,
        _localIpDataSource = localIpDataSource,
        _connectivityDataSource = connectivityDataSource;

  final IPublicIpDataSource _publicIpDataSource;
  final ILocalIpDataSource _localIpDataSource;
  final IConnectivityDataSource _connectivityDataSource;

  @override
  Future<String?> getPublicIp() async {
    try {
      return await _publicIpDataSource.getPublicIp();
    } catch (_) {
      // Return null on error (graceful degradation)
      return null;
    }
  }

  @override
  Future<String?> getLocalIp() async {
    try {
      return await _localIpDataSource.getLocalIp();
    } catch (_) {
      // Return null on error (graceful degradation)
      return null;
    }
  }

  @override
  Future<bool> isConnected() async {
    try {
      return await _connectivityDataSource.isConnected();
    } catch (_) {
      // Return false on error (fail-safe)
      return false;
    }
  }

  @override
  Future<NetworkInfoModel> getNetworkInfo() async {
    // Fetch all information in parallel for better performance
    final results = await Future.wait([
      getPublicIp(),
      getLocalIp(),
      isConnected(),
    ]);

    return NetworkInfoModel(
      publicIp: results[0] as String?,
      localIp: results[1] as String?,
      isConnected: results[2] as bool,
    );
  }
}
