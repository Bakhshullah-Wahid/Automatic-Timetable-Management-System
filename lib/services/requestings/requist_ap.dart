import 'dart:convert';
import 'package:attms/services/requestings/request_class.dart';
import 'package:http/http.dart' as http;

import '../../widget/base_api.dart';

class ClassRequestService {
  API api = API();
  Future<Map<String, dynamic>> submitClassRequest(ClassRequest request) async {
    final url = Uri.parse('${api.baseUrl}/class-request/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit request: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
