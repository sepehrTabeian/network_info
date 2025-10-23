/// Network Info Package
/// A standalone Flutter package for retrieving network information
///
/// Author: Sepehr Tabeian
/// License: MIT
/// Copyright (c) 2025 Sepehr Tabeian

// Dependency injection
import 'package:network_info/src/di/network_info_di.dart';
import 'package:network_info/src/domain/repository/i_network_info_repository.dart';

// Data layer exports (only config, not implementations)
export 'src/data/config/network_info_config.dart';
export 'src/domain/models/network_info_model.dart';

typedef NetworkInfo = INetworkInfoRepository;

/// Global instance of [NetworkInfoDI] for easy access
final networkInfoDI = NetworkInfoDI();
