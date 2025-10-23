import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'data/data_sources/public_ip_data_source_test.dart' as public_ip_test;
import 'domain/models/network_info_model_test.dart' as model_test;

void main() {
  group('Network Info Package Tests', () {
    group('Domain Layer', () {
      model_test.main();
    });

    group('Data Layer', () {
      public_ip_test.main();
    });

  });
}
