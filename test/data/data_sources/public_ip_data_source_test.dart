import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_info/src/data/config/network_info_config.dart';
import 'package:network_info/src/data/data_sources/public_ip_data_source.dart';

@GenerateMocks([http.Client])
import 'public_ip_data_source_test.mocks.dart';

void main() {
  late MockClient mockHttpClient;
  late PublicIpDataSource dataSource;
  late NetworkInfoConfig config;

  setUp(() {
    mockHttpClient = MockClient();
    config = const NetworkInfoConfig(
      publicIpServices: ['https://test.com/ip'],
      timeout: Duration(seconds: 5),
      retryCount: 1,
    );
    dataSource = PublicIpDataSource(
      httpClient: mockHttpClient,
      config: config,
    );
  });

  group('PublicIpDataSource', () {
    group('getPublicIp', () {
      test('returns IP when service responds successfully', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('1.2.3.4', 200),
        );

        final result = await dataSource.getPublicIp();

        expect(result, '1.2.3.4');
        verify(mockHttpClient.get(Uri.parse('https://test.com/ip'))).called(1);
      });

      test('returns null when all services fail', () async {
        when(mockHttpClient.get(any)).thenThrow(Exception('Network error'));

        final result = await dataSource.getPublicIp();

        expect(result, null);
      });

      test('tries next service when first fails', () async {
        final configMultiple = const NetworkInfoConfig(
          publicIpServices: [
            'https://test1.com/ip',
            'https://test2.com/ip',
          ],
          timeout: Duration(seconds: 5),
          retryCount: 1,
        );
        final dataSourceMultiple = PublicIpDataSource(
          httpClient: mockHttpClient,
          config: configMultiple,
        );

        when(mockHttpClient.get(Uri.parse('https://test1.com/ip')))
            .thenThrow(Exception('Error'));
        when(mockHttpClient.get(Uri.parse('https://test2.com/ip')))
            .thenAnswer((_) async => http.Response('5.6.7.8', 200));

        final result = await dataSourceMultiple.getPublicIp();

        expect(result, '5.6.7.8');
      });

      test('returns null for invalid IP format', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('invalid-ip', 200),
        );

        final result = await dataSource.getPublicIp();

        expect(result, null);
      });

      test('trims whitespace from response', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('  1.2.3.4  \n', 200),
        );

        final result = await dataSource.getPublicIp();

        expect(result, '1.2.3.4');
      });

      test('returns null for non-200 status code', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('Error', 500),
        );

        final result = await dataSource.getPublicIp();

        expect(result, null);
      });

      test('returns null for empty response', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('', 200),
        );

        final result = await dataSource.getPublicIp();

        expect(result, null);
      });

      test('validates IPv4 format correctly', () async {
        final validIps = [
          '0.0.0.0',
          '255.255.255.255',
          '192.168.1.1',
          '10.0.0.1',
        ];

        for (final ip in validIps) {
          when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response(ip, 200),
          );

          final result = await dataSource.getPublicIp();
          expect(result, ip, reason: 'Should accept valid IP: $ip');
        }
      });

      test('rejects invalid IPv4 formats', () async {
        final invalidIps = [
          '256.1.1.1',
          '1.256.1.1',
          '1.1.256.1',
          '1.1.1.256',
          '1.1.1',
          '1.1.1.1.1',
          'abc.def.ghi.jkl',
        ];

        for (final ip in invalidIps) {
          when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response(ip, 200),
          );

          final result = await dataSource.getPublicIp();
          expect(result, null, reason: 'Should reject invalid IP: $ip');
        }
      });
    });
  });
}
