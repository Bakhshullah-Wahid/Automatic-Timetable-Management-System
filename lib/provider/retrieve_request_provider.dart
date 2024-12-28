import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../widget/base_api.dart';

// StateNotifier to manage department fetching state
class RequestProviderNotifier extends StateNotifier<List<FetchingRequest>> {
  RequestProviderNotifier() : super([]);

  Future<void> retrieveRequest() async {
  
      API api = API();
      final response = await http.get(Uri.parse('${api.baseUrl}requests/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        state = responseBody
            .map((noteMap) => FetchingRequest.fromMap(noteMap))
            .toList();
      }
   
  }
}

// Provider to access RequestProviderNotifier
final requestProvider =
    StateNotifierProvider<RequestProviderNotifier, List<FetchingRequest>>(
        (ref) {
  return RequestProviderNotifier();
});

// FetchingRequest class definition
class FetchingRequest {
  int id;
  String status;
  String requesterDepartment;
  String requestedClass;
  String dateCreated;
  String purpose;

  FetchingRequest(
      {required this.id,
      required this.status,
      required this.requesterDepartment,
      required this.dateCreated,
      required this.purpose,
      required this.requestedClass});

  factory FetchingRequest.fromMap(Map<String, dynamic> map) {
    return FetchingRequest(
      id: map['id'] ?? 0,
      status: map['status'] ?? '',
      requesterDepartment: map['requester_department'] ?? '',
      requestedClass: map['requested_class'] ?? '',
      dateCreated: map['date_created'] ?? '',
      purpose: map['purpose'] ?? '',
    );
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'department_id': requesterDepartment,
      'class_id': requestedClass,
      'date_created': dateCreated,
      'purpose': purpose,
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingRequest(id: $id,department_id:$requesterDepartment,class_id:$requestedClass, date_created: $dateCreated ,purpose:$purpose ,status:$status)';
}
