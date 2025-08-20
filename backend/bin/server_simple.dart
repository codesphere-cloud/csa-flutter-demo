import 'dart:convert';
import 'dart:io';

void main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
  print('Server listening on port ${server.port}');

  await for (HttpRequest request in server) {
    // Add CORS headers
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type, Authorization');

    if (request.method == 'OPTIONS') {
      // Handle CORS preflight requests
      request.response.statusCode = 200;
      await request.response.close();
      continue;
    }

    if (request.uri.path == '/api/health' && request.method == 'GET') {
      // Health check endpoint for the backend itself
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({
        'status': 'healthy',
        'timestamp': DateTime.now().toIso8601String(),
        'service': 'microservice-dashboard-backend'
      }));
    } else if (request.uri.path == '/api/services' && request.method == 'GET') {
      // Return hardcoded services list
      final services = [
        {
          'name': 'Dashboard Backend',
          'url': '/api/health',
        },
        {
          'name': 'Google DNS',
          'url': 'https://8.8.8.8',
        },
        {
          'name': 'Public API',
          'url': 'https://api.publicapis.org/entries',
        },
        {
          'name': 'GitHub API',
          'url': 'https://api.github.com',
        },
        {
          'name': 'JSONPlaceholder',
          'url': 'https://jsonplaceholder.typicode.com/posts/1',
        },
        {
          'name': 'HttpBin',
          'url': 'https://httpbin.org/status/200',
        },
      ];

      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(services));
    } else {
      // Return 404 for other paths
      request.response.statusCode = 404;
      request.response.write('Not Found');
    }

    await request.response.close();
  }
}
