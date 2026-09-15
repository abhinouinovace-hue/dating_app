import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;

import '../../../../core/network/api_config.dart';
import '../../../../core/network/auth_session.dart';

class HttpProfileSetupRemoteDataSource {
  const HttpProfileSetupRemoteDataSource();

  static const _timeout = Duration(seconds: 15);

  Future<void> setupProfile({
    required String name,
    required String gender,
    required String language,
  }) async {
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Your login session is missing. Please log in again.');
    }

    final uri = Uri.parse('${ApiConfig.normalizedBaseUrl}/profile/setup');
    final requestBody = jsonEncode({
      'name': name,
      'gender': gender,
      'language': language,
    });

    dev.log('setupProfile → POST $uri', name: 'ProfileSetup');
    dev.log('setupProfile → token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...', name: 'ProfileSetup');
    dev.log('setupProfile → body: $requestBody', name: 'ProfileSetup');

    http.Response response;

    try {
      response = await http
          .post(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
            body: requestBody,
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw Exception('Could not reach the backend at ${uri.origin}.');
    } on http.ClientException catch (error) {
      throw Exception('Network error: ${error.message}');
    }

    dev.log('setupProfile ← ${response.statusCode}: ${response.body}', name: 'ProfileSetup');

    final data = _decodeResponse(response);
    if (response.statusCode == 404) {
      final serverMessage = data['message'] ?? 'Route not found';
      throw Exception(
        '$serverMessage\n'
        'URL: $uri\n'
        'Check that the Laravel route exists and accepts POST requests.',
      );
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        'Authentication failed. Please log in again.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['message'] ?? 'Profile setup failed (${response.statusCode}).',
      );
    }
  }

  Future<void> updateProfile({
    required String name,
    required String gender,
    required String email,
    required String phone,
    String? dateOfBirth,
  }) async {
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Your login session is missing. Please log in again.');
    }

    final uri = Uri.parse('${ApiConfig.normalizedBaseUrl}/profile/update');
    http.Response response;

    final body = <String, dynamic>{
      'name': name,
      'gender': gender,
      'email': email,
      'phone': phone,
    };
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
      body['date_of_birth'] = dateOfBirth;
    }

    try {
      response = await http
          .post(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw Exception('Could not reach the backend at ${uri.origin}.');
    } on http.ClientException catch (error) {
      throw Exception('Network error: ${error.message}');
    }

    final data = _decodeResponse(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['message'] ?? 'Profile update failed (${response.statusCode}).',
      );
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.body.trim().isEmpty) return <String, dynamic>{};

    try {
      final decoded = jsonDecode(response.body);
      return decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{'data': decoded};
    } on FormatException {
      throw Exception('Backend returned an invalid response.');
    }
  }
}
