import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:network_info/network_info.dart';
import 'package:network_info/src/data/data_sources/connectivity_data_source.dart';
import 'package:network_info/src/data/data_sources/local_ip_data_source.dart';
import 'package:network_info/src/data/data_sources/public_ip_data_source.dart';

void main() {
  final getIt = GetIt.instance;

  setUp(() {
    // Reset GetIt before each test
    NetworkInfoDI.reset();
    if (getIt.isRegistered<http.Client>()) {
      getIt.unregister<http.Client>();
    }
    if (getIt.isRegistered<Connectivity>()) {
      getIt.unregister<Connectivity>();
    }
    if (getIt.isRegistered<NetworkInfoConfig>()) {
      getIt.unregister<NetworkInfoConfig>();
    }
  });

  tearDown(() {
    NetworkInfoDI.reset();
  });

  group('NetworkInfoDI', () {
    group('setupNetworkInfoDI', () {
      test('registers all dependencies', () {
        NetworkInfoDI.setupNetworkInfoDI();

        expect(getIt.isRegistered<NetworkInfoConfig>(), true);
        expect(getIt.isRegistered<http.Client>(), true);
        expect(getIt.isRegistered<Connectivity>(), true);
        expect(getIt.isRegistered<IPublicIpDataSource>(), true);
        expect(getIt.isRegistered<ILocalIpDataSource>(), true);
        expect(getIt.isRegistered<IConnectivityDataSource>(), true);
        expect(getIt.isRegistered<INetworkInfoRepository>(), true);
      });

      test('sets isInitialized to true', () {
        expect(NetworkInfoDI.isInitialized, false);

        NetworkInfoDI.setupNetworkInfoDI();

        expect(NetworkInfoDI.isInitialized, true);
      });

      test('does not re-register if already initialized', () {
        NetworkInfoDI.setupNetworkInfoDI();
        final firstRepo = getIt<INetworkInfoRepository>();

        NetworkInfoDI.setupNetworkInfoDI();
        final secondRepo = getIt<INetworkInfoRepository>();

        expect(identical(firstRepo, secondRepo), true);
      });

      test('uses custom HTTP client when provided', () {
        final customClient = http.Client();

        NetworkInfoDI.setupNetworkInfoDI(customHttpClient: customClient);

        final registeredClient = getIt<http.Client>();
        expect(identical(registeredClient, customClient), true);
      });

      test('uses custom connectivity when provided', () {
        final customConnectivity = Connectivity();

        NetworkInfoDI.setupNetworkInfoDI(
          customConnectivity: customConnectivity,
        );

        final registeredConnectivity = getIt<Connectivity>();
        expect(identical(registeredConnectivity, customConnectivity), true);
      });

      test('uses custom config when provided', () {
        const customConfig = NetworkInfoConfig(
          publicIpServices: ['https://custom.com'],
          timeout: Duration(seconds: 10),
        );

        NetworkInfoDI.setupNetworkInfoDI(config: customConfig);

        final registeredConfig = getIt<NetworkInfoConfig>();
        expect(registeredConfig.publicIpServices, ['https://custom.com']);
        expect(registeredConfig.timeout, const Duration(seconds: 10));
      });

      test('registers repository as singleton', () {
        NetworkInfoDI.setupNetworkInfoDI();

        final repo1 = getIt<INetworkInfoRepository>();
        final repo2 = getIt<INetworkInfoRepository>();

        expect(identical(repo1, repo2), true);
      });

      test('registers data sources as singletons', () {
        NetworkInfoDI.setupNetworkInfoDI();

        final publicIp1 = getIt<IPublicIpDataSource>();
        final publicIp2 = getIt<IPublicIpDataSource>();

        expect(identical(publicIp1, publicIp2), true);
      });
    });

    group('reset', () {
      test('unregisters all dependencies', () {
        NetworkInfoDI.setupNetworkInfoDI();
        expect(getIt.isRegistered<INetworkInfoRepository>(), true);

        NetworkInfoDI.reset();

        expect(getIt.isRegistered<INetworkInfoRepository>(), false);
        expect(getIt.isRegistered<IPublicIpDataSource>(), false);
        expect(getIt.isRegistered<ILocalIpDataSource>(), false);
        expect(getIt.isRegistered<IConnectivityDataSource>(), false);
      });

      test('sets isInitialized to false', () {
        NetworkInfoDI.setupNetworkInfoDI();
        expect(NetworkInfoDI.isInitialized, true);

        NetworkInfoDI.reset();

        expect(NetworkInfoDI.isInitialized, false);
      });

      test('allows re-initialization after reset', () {
        NetworkInfoDI.setupNetworkInfoDI();
        NetworkInfoDI.reset();

        NetworkInfoDI.setupNetworkInfoDI();

        expect(NetworkInfoDI.isInitialized, true);
        expect(getIt.isRegistered<INetworkInfoRepository>(), true);
      });
    });

    group('NetworkInfoGetIt extension', () {
      test('provides easy access to repository', () {
        NetworkInfoDI.setupNetworkInfoDI();

        final repo = getIt.networkInfo;

        expect(repo, isA<INetworkInfoRepository>());
      });
    });
  });
}
