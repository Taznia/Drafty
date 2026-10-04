import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_controller.dart';
import 'features/auth/presentation/auth_gate.dart';

void main() {
  runApp(const ProviderScope(child: CvMakerApp()));
}

class CvMakerApp extends ConsumerStatefulWidget {
  const CvMakerApp({super.key});

  @override
  ConsumerState<CvMakerApp> createState() => _CvMakerAppState();
}

class _CvMakerAppState extends ConsumerState<CvMakerApp> {
  @override
  void initState() {
    super.initState();
    ref.read(appThemeProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(appThemeProvider);
    return MaterialApp(
      title: 'Draftly CV',
      debugShowCheckedModeBanner: false,
      theme: mode == AppThemeMode.white ? AppTheme.white : AppTheme.light,
      darkTheme: mode == AppThemeMode.black ? AppTheme.black : AppTheme.dark,
      themeMode: mode == AppThemeMode.light || mode == AppThemeMode.white ? ThemeMode.light : ThemeMode.dark,
      home: const AuthGate(),
    );
  }
}
