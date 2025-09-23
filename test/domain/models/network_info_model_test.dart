import 'package:flutter_test/flutter_test.dart';
import 'package:network_info/network_info.dart';

void main() {
  group('NetworkInfoModel', () {
    group('Constructor', () {
      test('creates model with all fields', () {
        const model = NetworkInfoModel(
          publicIp: '1.2.3.4',
          localIp: '192.168.1.1',
          isConnected: true,
        );

        expect(model.publicIp, '1.2.3.4');
        expect(model.localIp, '192.168.1.1');
        expect(model.isConnected, true);
      });

      test('creates model with null IPs', () {
        const model = NetworkInfoModel(
          publicIp: null,
          localIp: null,
          isConnected: false,
        );

        expect(model.publicIp, null);
        expect(model.localIp, null);
        expect(model.isConnected, false);
      });

      test('defaults isConnected to false', () {
        const model = NetworkInfoModel();

        expect(model.isConnected, false);
      });
    });

    group('copyWith', () {
      test('copies with updated publicIp', () {
        const model = NetworkInfoModel(publicIp: '1.2.3.4');
        final updated = model.copyWith(publicIp: '5.6.7.8');

        expect(updated.publicIp, '5.6.7.8');
        expect(updated.localIp, model.localIp);
        expect(updated.isConnected, model.isConnected);
      });

      test('copies with updated localIp', () {
        const model = NetworkInfoModel(localIp: '192.168.1.1');
        final updated = model.copyWith(localIp: '192.168.1.2');

        expect(updated.localIp, '192.168.1.2');
        expect(updated.publicIp, model.publicIp);
        expect(updated.isConnected, model.isConnected);
      });

      test('copies with updated isConnected', () {
        const model = NetworkInfoModel(isConnected: false);
        final updated = model.copyWith(isConnected: true);

        expect(updated.isConnected, true);
        expect(updated.publicIp, model.publicIp);
        expect(updated.localIp, model.localIp);
      });

      test('copies with all fields updated', () {
        const model = NetworkInfoModel();
        final updated = model.copyWith(
          publicIp: '1.2.3.4',
          localIp: '192.168.1.1',
          isConnected: true,
        );

        expect(updated.publicIp, '1.2.3.4');
        expect(updated.localIp, '192.168.1.1');
        expect(updated.isConnected, true);
      });
    });

    group('hasAnyIp', () {
      test('returns true when publicIp is available', () {
        const model = NetworkInfoModel(publicIp: '1.2.3.4');
        expect(model.hasAnyIp, true);
      });

      test('returns true when localIp is available', () {
        const model = NetworkInfoModel(localIp: '192.168.1.1');
        expect(model.hasAnyIp, true);
      });

      test('returns true when both IPs are available', () {
        const model = NetworkInfoModel(
          publicIp: '1.2.3.4',
          localIp: '192.168.1.1',
        );
        expect(model.hasAnyIp, true);
      });

      test('returns false when no IP is available', () {
        const model = NetworkInfoModel();
        expect(model.hasAnyIp, false);
      });
    });

    group('bestAvailableIp', () {
      test('returns publicIp when available', () {
        const model = NetworkInfoModel(
          publicIp: '1.2.3.4',
          localIp: '192.168.1.1',
        );
        expect(model.bestAvailableIp, '1.2.3.4');
      });

      test('returns localIp when publicIp is null', () {
        const model = NetworkInfoModel(localIp: '192.168.1.1');
        expect(model.bestAvailableIp, '192.168.1.1');
      });

      test('returns null when both are null', () {
        const model = NetworkInfoModel();
        expect(model.bestAvailableIp, null);
      });
    });

    group('Equality', () {
      test('two models with same values are equal', () {
        const model1 = NetworkInfoModel(
          publicIp: '1.2.3.4',
          localIp: '192.168.1.1',
          isConnected: true,
        );
        const model2 = NetworkInfoModel(
          publicIp: '1.2.3.4',
          localIp: '192.168.1.1',
          isConnected: true,
        );

        expect(model1, model2);
        expect(model1.hashCode, model2.hashCode);
      });

      test('two models with different values are not equal', () {
        const model1 = NetworkInfoModel(publicIp: '1.2.3.4');
        const model2 = NetworkInfoModel(publicIp: '5.6.7.8');

        expect(model1, isNot(model2));
      });
    });

    group('toString', () {
      test('returns string representation', () {
        const model = NetworkInfoModel(
          publicIp: '1.2.3.4',
          localIp: '192.168.1.1',
          isConnected: true,
        );

        expect(
          model.toString(),
          'NetworkInfoModel(publicIp: 1.2.3.4, localIp: 192.168.1.1, isConnected: true)',
        );
      });
    });
  });
}
