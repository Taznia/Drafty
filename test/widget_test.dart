import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cv_maker/features/auth/providers/auth_provider.dart';
import 'package:cv_maker/main.dart';
import 'package:cv_maker/models/auth_user.dart';

void main() {
  testWidgets('unauthenticated users see the login flow', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [authControllerProvider.overrideWith(_UnauthenticatedController.new)], child: const CvMakerApp()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back.'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);
  });
}

class _UnauthenticatedController extends AuthController {
  @override
  Future<AuthSession?> build() async => null;
}
