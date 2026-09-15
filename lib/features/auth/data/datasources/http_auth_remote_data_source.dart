import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/network/api_config.dart';
import '../../../../core/network/auth_session.dart';

class ApiService {
  static final Uri _sendOtpUri = Uri.parse(
    '${ApiConfig.normalizedBaseUrl}/auth/send-otp',
  );
  static final Uri _verifyOtpUri = Uri.parse(
    '${ApiConfig.normalizedBaseUrl}/auth/verify-otp',
  );
  static const Duration _requestTimeout = Duration(seconds: 15);

  static Future<Map<String, dynamic>> sendOtp({
    required String phone,
  }) {
    final normalizedPhone = _normalizePhone(phone);

    return _postJson(
      _sendOtpUri,
      body: {
        'phone': normalizedPhone,
      },
    );
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final normalizedPhone = _normalizePhone(phone);

    final data = await _postJson(
      _verifyOtpUri,
      body: {
        'phone': normalizedPhone,
        'otp': otp.trim(),
      },
    );

    final token = _readAccessToken(data);
    if (token == null || token.isEmpty) {
      throw Exception(
        'OTP was verified, but the backend did not return an access token.',
      );
    }

    AuthSession.accessToken = token;
    return data;
  }

  static Future<Map<String, dynamic>> _postJson(
    Uri uri, {
    required Map<String, dynamic> body,
  }) async {
    http.Response response;

    try {
      response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      )
          .timeout(_requestTimeout);
    } on TimeoutException {
      throw Exception(
        'Could not reach the backend at ${uri.origin}. '
        'Check that Laravel is running and that this phone can access that IP address on port ${uri.port}.',
      );
    } on http.ClientException catch (error) {
      throw Exception(
        'Network error while connecting to ${uri.origin}: ${error.message}',
      );
    } catch (error) {
      throw Exception('Request failed: $error');
    }

    final data = _decodeResponse(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Request failed with status ${response.statusCode}.',
    );
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    final responseBody = response.body.trim();

    if (responseBody.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return <String, dynamic>{
        'data': decoded,
      };
    } on FormatException {
      throw Exception(
        'Backend returned an invalid response (${response.statusCode}).',
      );
    }
  }

  static String _normalizePhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');

    // The Laravel API expects the 10-digit mobile number, without +91.
    if (digitsOnly.length <= 10) {
      return digitsOnly;
    }

    return digitsOnly.substring(digitsOnly.length - 10);
  }

  static String? _readAccessToken(Map<String, dynamic> data) {
    final nestedData = data['data'];
    final candidates = [
      data['token'],
      data['access_token'],
      nestedData is Map ? nestedData['token'] : null,
      nestedData is Map ? nestedData['access_token'] : null,
    ];

    for (final candidate in candidates) {
      if (candidate is String && candidate.isNotEmpty) return candidate;
    }
    return null;
  }
}
