import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../models/auth_user.dart';

class AuthApiService {
  AuthApiService({http.Client? client, FlutterSecureStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'draftly_access_token';
  final http.Client _client;
  final FlutterSecureStorage _storage;

  Future<AuthSession> login({required String email, required String password}) async {
    final response = await _client.post(_uri('/auth/login'), headers: _jsonHeaders, body: jsonEncode({'email': email, 'password': password}));
    return _sessionFromResponse(response);
  }

  Future<AuthSession> register({required String name, required String email, required String password}) async {
    final response = await _client.post(_uri('/auth/register'), headers: _jsonHeaders, body: jsonEncode({'name': name, 'email': email, 'password': password}));
    return _sessionFromResponse(response);
  }

  Future<AuthUser> currentUser(String token) async {
    final response = await _client.get(_uri('/auth/me'), headers: _authHeaders(token));
    _throwForError(response);
    return AuthUser.fromJson((jsonDecode(response.body) as Map<String, dynamic>)['data']['user'] as Map<String, dynamic>);
  }

  Future<void> logout(String token) async {
    await _client.post(_uri('/auth/logout'), headers: _authHeaders(token));
    await clearToken();
  }

  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}$path');
  Map<String, String> get _jsonHeaders => const {'Content-Type': 'application/json', 'Accept': 'application/json'};
  Map<String, String> _authHeaders(String token) => {..._jsonHeaders, 'Authorization': 'Bearer $token'};

  Future<AuthSession> _sessionFromResponse(http.Response response) async {
    _throwForError(response);
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    final session = AuthSession(accessToken: data['accessToken'] as String, user: AuthUser.fromJson(data['user'] as Map<String, dynamic>));
    await _storage.write(key: _tokenKey, value: session.accessToken);
    return session;
  }

  void _throwForError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    String message = 'Something went wrong. Please try again.';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      message = ((body['error'] as Map<String, dynamic>?)?['message'] as String?) ?? message;
    } catch (_) {}
    throw AuthApiException(message, response.statusCode);
  }
}

class AuthApiException implements Exception {
  const AuthApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
