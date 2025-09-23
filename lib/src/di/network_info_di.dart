import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:network_info/src/data/config/network_info_config.dart';
import 'package:network_info/src/data/data_sources/connectivity_data_source.dart';
import 'package:network_info/src/data/data_sources/local_ip_data_source.dart';
import 'package:network_info/src/data/data_sources/public_ip_data_source.dart';
import 'package:network_info/src/data/repository/network_info_repository_impl.dart';
import 'package:network_info/src/domain/repository/i_network_info_repository.dart';

/// Dependency injection setup for network info package
/// Follows Dependency Inversion Principle
class NetworkInfoDI {
  static bool _isInitialized = false;

  /// Setup dependency injection for network info
  /// Call this method once during app initialization
  static void setupNetworkInfoDI({
    http.Client? customHttpClient,
    Connectivity? customConnectivity,
    NetworkInfoConfig? config,
  }) {
    if (_isInitialized) {
      return;
    }

    final getIt = GetIt.instance;

    // Register configuration
    if (!getIt.isRegistered<NetworkInfoConfig>()) {
      getIt.registerLazySingleton<NetworkInfoConfig>(
        () => config ?? const NetworkInfoConfig(),
      );
    }

    // Register HTTP client
    if (!getIt.isRegistered<http.Client>()) {
      getIt.registerLazySingleton<http.Client>(
        () => customHttpClient ?? http.Client(),
      );
    }

    // Register Connectivity
    if (!getIt.isRegistered<Connectivity>()) {
      getIt.registerLazySingleton<Connectivity>(
        () => customConnectivity ?? Connectivity(),
      );
    }

    // Register data sources
    if (!getIt.isRegistered<IPublicIpDataSource>()) {
      getIt.registerLazySingleton<IPublicIpDataSource>(
        () => PublicIpDataSource(
          httpClient: getIt<http.Client>(),
          config: getIt<NetworkInfoConfig>(),
        ),
      );
    }

    if (!getIt.isRegistered<ILocalIpDataSource>()) {
      getIt.registerLazySingleton<ILocalIpDataSource>(
        () => LocalIpDataSource(),
      );
    }

    if (!getIt.isRegistered<IConnectivityDataSource>()) {
      getIt.registerLazySingleton<IConnectivityDataSource>(
        () => ConnectivityDataSource(
          connectivity: getIt<Connectivity>(),
        ),
      );
    }

    // Register repository
    if (!getIt.isRegistered<INetworkInfoRepository>()) {
      getIt.registerLazySingleton<INetworkInfoRepository>(
        () => NetworkInfoRepositoryImpl(
          publicIpDataSource: getIt<IPublicIpDataSource>(),
          localIpDataSource: getIt<ILocalIpDataSource>(),
          connectivityDataSource: getIt<IConnectivityDataSource>(),
        ),
      );
    }

    _isInitialized = true;
  }

  /// Reset DI container (useful for testing)
  static void reset() {
    final getIt = GetIt.instance;

    if (getIt.isRegistered<INetworkInfoRepository>()) {
      getIt.unregister<INetworkInfoRepository>();
    }

    if (getIt.isRegistered<IConnectivityDataSource>()) {
      getIt.unregister<IConnectivityDataSource>();
    }

    if (getIt.isRegistered<ILocalIpDataSource>()) {
      getIt.unregister<ILocalIpDataSource>();
    }

    if (getIt.isRegistered<IPublicIpDataSource>()) {
      getIt.unregister<IPublicIpDataSource>();
    }

    if (getIt.isRegistered<Connectivity>()) {
      getIt.unregister<Connectivity>();
    }

    if (getIt.isRegistered<http.Client>()) {
      getIt.unregister<http.Client>();
    }

    if (getIt.isRegistered<NetworkInfoConfig>()) {
      getIt.unregister<NetworkInfoConfig>();
    }

    _isInitialized = false;
  }

  /// Check if DI is initialized
  static bool get isInitialized => _isInitialized;
}

/// Extension for easy access to network info repository from GetIt
extension NetworkInfoGetIt on GetIt {
  INetworkInfoRepository get networkInfo => get<INetworkInfoRepository>();
}
