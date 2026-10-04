import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { dark, light, black, white }

final appThemeProvider = NotifierProvider<AppThemeController, AppThemeMode>(AppThemeController.new);

class AppThemeController extends Notifier<AppThemeMode> {
  static const _key = 'draftly_app_theme';

  @override
  AppThemeMode build() => AppThemeMode.dark;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_key);
    if (saved != null) state = AppThemeMode.values.firstWhere((mode) => mode.name == saved, orElse: () => AppThemeMode.dark);
  }

  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, mode.name);
  }
}