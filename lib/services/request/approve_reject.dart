import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> updateRequestStatus(int requestId, String status) async {
  const String baseUrl = 'http://127.0.0.1:8000/';
  final url = Uri.parse('$baseUrl/class-requests/$requestId/');

await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

  
}
