import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:async';


class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        // Android emulator needs 10.0.2.2 to access host's localhost
        return 'http://10.0.2.2:5000';
      }
    }
    // For testing, print the URL being used
    print('Using server URL: $baseUrl');
    return 'http://10.0.2.2:5000';
  }

  Future<bool> initiateSearch(String query) async {
    try {
      print('Attempting to connect to: $baseUrl/search');
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Request timed out');
          throw TimeoutException('The connection has timed out');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error during search: $e');
      return false;
    }
  }

  Future<bool> checkSearchStatus() async {
    try {
      print('Checking status at: $baseUrl/status');
      final response = await http.get(
        Uri.parse('$baseUrl/status'),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('Status check timed out');
          throw TimeoutException('The connection has timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'complete';
      }
      print('Status check failed with code: ${response.statusCode}');
      return false;
    } catch (e) {
      print('Error checking status: $e');
      return false;
    }
  }

  Future<bool> testConnection() async {
    try {
      print('Testing connection to: $baseUrl');
      final response = await http.get(
        Uri.parse('$baseUrl/status'),
      ).timeout(
        const Duration(seconds: 5),
      );
      print('Test connection result: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Test connection failed: $e');
      return false;
    }
  }
}