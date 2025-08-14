import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router();

  // GET endpoint for services
  router.get('/api/services', (Request request) {
    final services = [
      {
        'name': 'Google DNS',
        'url': 'https://8.8.8.8',
      },
      {
        'name': 'Public API',
        'url': 'https://api.publicapis.org/entries',
      },
      {
        'name': 'GitHub',
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

    final jsonResponse = jsonEncode(services);

    return Response.ok(
      jsonResponse,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    );
  });

  // Handle CORS preflight requests
  router.options('/api/<path|.*>', (Request request) {
    return Response.ok(
      '',
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    );
  });

  // Create a handler with CORS middleware
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  // Start the server
  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    8080,
  );

  print('Server listening on port ${server.port}');
}
