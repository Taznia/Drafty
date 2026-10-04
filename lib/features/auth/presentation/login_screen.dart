import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.initialError});

  final String? initialError;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isLoading = auth.isLoading;
    final error = auth.hasError ? auth.error.toString() : widget.initialError;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.auto_awesome_rounded, color: AppColors.ink)),
                  const SizedBox(height: 30),
                  Text('Welcome back.', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text('Your next great application starts here.', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 32),
                  if (error != null) _ErrorBanner(message: error),
                  TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline_rounded)), validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email.' : null),
                  const SizedBox(height: 14),
                  TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline_rounded)), validator: (value) => value == null || value.isEmpty ? 'Enter your password.' : null),
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot password?'))),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: FilledButton(onPressed: isLoading ? null : _login, child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Log in'))),
                  const SizedBox(height: 20),
                  Row(children: [Expanded(child: Divider(color: Theme.of(context).dividerColor)), const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or')), Expanded(child: Divider(color: Theme.of(context).dividerColor))]),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SignupScreen())), child: const Text('Create an account'))),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authControllerProvider.notifier).login(email: _email.text.trim(), password: _password.text);
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: AppColors.coral.withValues(alpha: .12), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.coral.withValues(alpha: .4))), child: Text(message, style: const TextStyle(color: AppColors.coralSoft)));
}
