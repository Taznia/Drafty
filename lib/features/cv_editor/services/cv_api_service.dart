import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../models/cv_draft.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/services/auth_api_service.dart';

final cvApiServiceProvider = Provider<CvApiService>((ref) => CvApiService(ref.read(authApiServiceProvider)));

class CvApiService {
  CvApiService(this._auth, {http.Client? client}) : _client = client ?? http.Client();

  final AuthApiService _auth;
  final http.Client _client;

  Future<void> create(CvDraft draft) async {
    final token = await _auth.readToken();
    if (token == null) throw const CvApiException('Please sign in before saving a CV.');
    final response = await _client.post(Uri.parse('${AppConfig.apiBaseUrl}/cvs'), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'}, body: jsonEncode(draft.toApiPayload()));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CvApiException(_message(response));
    }
  }

  String _message(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ((body['error'] as Map<String, dynamic>?)?['message'] as String?) ?? 'The CV could not be saved.';
    } catch (_) {
      return 'The CV could not be saved.';
    }
  }
}

class CvApiException implements Exception {
  const CvApiException(this.message);
  final String message;

  @override
  String toString() => message;
}