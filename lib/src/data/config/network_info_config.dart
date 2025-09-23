/// Configuration for network info package
class NetworkInfoConfig {
  const NetworkInfoConfig({
    this.publicIpServices = defaultPublicIpServices,
    this.timeout = const Duration(seconds: 5),
    this.retryCount = 3,
  });

  /// List of public IP services to try (in order)
  final List<String> publicIpServices;

  /// Timeout for each service request
  final Duration timeout;

  /// Number of retry attempts per service
  final int retryCount;

  /// Default public IP services
  static const List<String> defaultPublicIpServices = [
    'https://api.ipify.org?format=text',
    'https://icanhazip.com',
    'https://ifconfig.me/ip',
    'https://api.my-ip.io/ip',
  ];

  NetworkInfoConfig copyWith({
    List<String>? publicIpServices,
    Duration? timeout,
    int? retryCount,
  }) {
    return NetworkInfoConfig(
      publicIpServices: publicIpServices ?? this.publicIpServices,
      timeout: timeout ?? this.timeout,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}
