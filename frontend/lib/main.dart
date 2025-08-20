import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microservice Status Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StatusDashboard(),
    );
  }
}

enum Status { loading, up, down }

class ServiceStatus {
  final String name;
  final String url;
  Status status;

  ServiceStatus({
    required this.name,
    required this.url,
    this.status = Status.loading,
  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}

class StatusDashboard extends StatefulWidget {
  const StatusDashboard({super.key});

  @override
  State<StatusDashboard> createState() => _StatusDashboardState();
}

class _StatusDashboardState extends State<StatusDashboard> {
  List<ServiceStatus> services = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Fetch services from backend
      final response = await http.get(
        Uri.parse('/api/services'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> serviceList = jsonDecode(response.body);
        setState(() {
          services = serviceList
              .map((json) => ServiceStatus.fromJson(json))
              .toList();
          isLoading = false;
        });

        // Start health checks for each service
        _performHealthChecks();
      } else {
        setState(() {
          error = 'Failed to load services: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading services: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _performHealthChecks() async {
    for (int i = 0; i < services.length; i++) {
      _checkServiceHealth(i);
    }
  }

  Future<void> _checkServiceHealth(int index) async {
    try {
      final service = services[index];
      
      // Perform health check with timeout
      final response = await http
          .head(Uri.parse(service.url))
          .timeout(const Duration(seconds: 10));

      setState(() {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          services[index].status = Status.up;
        } else {
          services[index].status = Status.down;
        }
      });
    } catch (e) {
      setState(() {
        services[index].status = Status.down;
      });
    }
  }

  Widget _buildStatusIcon(Status status) {
    switch (status) {
      case Status.loading:
        return const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case Status.up:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 24,
        );
      case Status.down:
        return const Icon(
          Icons.error,
          color: Colors.red,
          size: 24,
        );
    }
  }

  String _getStatusText(Status status) {
    switch (status) {
      case Status.loading:
        return 'Checking...';
      case Status.up:
        return 'Online';
      case Status.down:
        return 'Offline';
    }
  }

  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.loading:
        return Colors.grey;
      case Status.up:
        return Colors.green;
      case Status.down:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Microservice Status Dashboard'),
        actions: [
          IconButton(
            onPressed: isLoading ? null : _loadServices,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading && services.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              error!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadServices,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (services.isEmpty) {
      return const Center(
        child: Text('No services found'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    'Total Services',
                    services.length.toString(),
                    Colors.blue,
                  ),
                  _buildSummaryItem(
                    'Online',
                    services.where((s) => s.status == Status.up).length.toString(),
                    Colors.green,
                  ),
                  _buildSummaryItem(
                    'Offline',
                    services.where((s) => s.status == Status.down).length.toString(),
                    Colors.red,
                  ),
                  _buildSummaryItem(
                    'Checking',
                    services.where((s) => s.status == Status.loading).length.toString(),
                    Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: _buildStatusIcon(service.status),
                    title: Text(
                      service.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(service.url),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(service.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getStatusColor(service.status),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getStatusText(service.status),
                        style: TextStyle(
                          color: _getStatusColor(service.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Re-check this specific service
                      _checkServiceHealth(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
