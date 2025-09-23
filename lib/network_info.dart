/// Network Info Package
/// A standalone Flutter package for retrieving network information
///
/// Author: Sepehr Tabeian
/// License: MIT
/// Copyright (c) 2025 Sepehr Tabeian
library network_info;

// Data layer exports (only config, not implementations)
export 'src/data/config/network_info_config.dart';
// Dependency injection
export 'src/di/network_info_di.dart';
// Domain layer exports
export 'src/domain/exceptions/network_info_exception.dart';
export 'src/domain/models/network_info_model.dart';
export 'src/domain/repository/i_network_info_repository.dart';
