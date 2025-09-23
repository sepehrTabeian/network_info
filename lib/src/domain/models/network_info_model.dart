/// Model representing network information
class NetworkInfoModel {
  const NetworkInfoModel({
    this.publicIp,
    this.localIp,
    this.isConnected = false,
  });

  /// Public IP address (visible on the internet)
  final String? publicIp;

  /// Local IP address (LAN/Wi-Fi)
  final String? localIp;

  /// Whether the device is connected to a network
  final bool isConnected;

  /// Creates a copy with updated fields
  NetworkInfoModel copyWith({
    String? publicIp,
    String? localIp,
    bool? isConnected,
  }) {
    return NetworkInfoModel(
      publicIp: publicIp ?? this.publicIp,
      localIp: localIp ?? this.localIp,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  /// Checks if any IP is available
  bool get hasAnyIp => publicIp != null || localIp != null;

  /// Gets the best available IP (prefers public over local)
  String? get bestAvailableIp => publicIp ?? localIp;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NetworkInfoModel &&
        other.publicIp == publicIp &&
        other.localIp == localIp &&
        other.isConnected == isConnected;
  }

  @override
  int get hashCode =>
      publicIp.hashCode ^ localIp.hashCode ^ isConnected.hashCode;

  @override
  String toString() {
    return 'NetworkInfoModel(publicIp: $publicIp, localIp: $localIp, isConnected: $isConnected)';
  }
}
