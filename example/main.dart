import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:network_info/network_info.dart';

void main() {
  // Initialize the package
  NetworkInfoDI.setupNetworkInfoDI();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Info Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NetworkInfoScreen(),
    );
  }
}

class NetworkInfoScreen extends StatefulWidget {
  const NetworkInfoScreen({super.key});

  @override
  State<NetworkInfoScreen> createState() => _NetworkInfoScreenState();
}

class _NetworkInfoScreenState extends State<NetworkInfoScreen> {
  final _networkInfo = GetIt.instance<INetworkInfoRepository>();

  String? _publicIp;
  String? _localIp;
  bool _isConnected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNetworkInfo();
  }

  Future<void> _loadNetworkInfo() async {
    setState(() => _isLoading = true);

    try {
      final info = await _networkInfo.getNetworkInfo();

      setState(() {
        _publicIp = info.publicIp;
        _localIp = info.localIp;
        _isConnected = info.isConnected;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Info Example'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadNetworkInfo,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildInfoCard(
                    title: 'Connection Status',
                    value: _isConnected ? 'Connected' : 'Disconnected',
                    icon: _isConnected ? Icons.wifi : Icons.wifi_off,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Public IP Address',
                    value: _publicIp ?? 'Not available',
                    icon: Icons.public,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Local IP Address',
                    value: _localIp ?? 'Not available',
                    icon: Icons.router,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _loadNetworkInfo,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
          Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
