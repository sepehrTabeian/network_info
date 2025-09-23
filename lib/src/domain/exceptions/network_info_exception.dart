/// Base exception for network info operations
class NetworkInfoException implements Exception {
  const NetworkInfoException(this.message, {this.originalError});

  final String message;
  final dynamic originalError;

  @override
  String toString() => 'NetworkInfoException: $message';
}

/// Exception for public IP retrieval failures
class PublicIpException extends NetworkInfoException {
  const PublicIpException(super.message, {super.originalError});

  @override
  String toString() => 'PublicIpException: $message';
}

/// Exception for local IP retrieval failures
class LocalIpException extends NetworkInfoException {
  const LocalIpException(super.message, {super.originalError});

  @override
  String toString() => 'LocalIpException: $message';
}

/// Exception for connectivity check failures
class ConnectivityException extends NetworkInfoException {
  const ConnectivityException(super.message, {super.originalError});

  @override
  String toString() => 'ConnectivityException: $message';
}
