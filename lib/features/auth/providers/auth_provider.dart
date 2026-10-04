import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/auth_user.dart';
import '../services/auth_api_service.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) => AuthApiService());

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  late final AuthApiService _api;

  @override
  Future<AuthSession?> build() async {
    _api = ref.read(authApiServiceProvider);
    final token = await _api.readToken();
    if (token == null) return null;

    try {
      final user = await _api.currentUser(token);
      return AuthSession(user: user, accessToken: token);
    } catch (_) {
      await _api.clearToken();
      return null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _api.login(email: email, password: password));
  }

  Future<void> register({required String name, required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _api.register(name: name, email: email, password: password));
  }

  Future<void> logout() async {
    final session = state.value;
    if (session != null) await _api.logout(session.accessToken);
    state = const AsyncData(null);
  }
}
