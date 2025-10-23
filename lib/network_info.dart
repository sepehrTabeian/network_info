/// Network Info Package
/// A standalone Flutter package for retrieving network information
///
/// Author: Sepehr Tabeian
/// License: MIT
/// Copyright (c) 2025 Sepehr Tabeian
///
/// ## Usage
///
/// The simplest way to use this package is through the [NetworkInfo] class:
///
/// ```dart
/// // Get public IP
/// final publicIp = await NetworkInfo.getPublicIp();
///
/// // Get local IP
/// final localIp = await NetworkInfo.getLocalIp();
///
/// // Check connectivity
/// final isConnected = await NetworkInfo.isConnected();
///
/// // Get all network info at once
/// final info = await NetworkInfo.getNetworkInfo();
/// ```
///
/// ### Advanced Usage
///
/// For advanced use cases, you can still access the repository directly:
///
/// ```dart
/// // Initialize DI
/// NetworkInfoDI.setupNetworkInfoDI();
///
/// // Get repository
/// final repository = GetIt.instance<INetworkInfoRepository>();
/// final info = await repository.getNetworkInfo();
/// ```
library;

// ==================== Primary API ====================
// This is the recommended way to use the package
export 'src/api/network_info.dart';

// ==================== Core Models & Config ====================
export 'src/data/config/network_info_config.dart';

// ==================== Advanced/Optional Exports ====================
// For advanced users who want direct access to DI and repository
export 'src/di/network_info_di.dart';
export 'src/domain/models/network_info_model.dart';
export 'src/domain/repository/i_network_info_repository.dart';



