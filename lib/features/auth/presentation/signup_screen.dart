import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final error = auth.hasError ? auth.error.toString() : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Create your account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('A sharper CV starts with a clear space to build it.', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Your password is used only to create your account and is never stored in the app.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              if (error != null) Container(width: double.infinity, padding: const EdgeInsets.all(13), margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: AppColors.coral.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)), child: Text(error, style: const TextStyle(color: AppColors.coralSoft))),
              TextFormField(controller: _name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline_rounded)), validator: (value) => value == null || value.trim().length < 2 ? 'Enter your name.' : null),
              const SizedBox(height: 14),
              TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline_rounded)), validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email.' : null),
              const SizedBox(height: 14),
              TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline_rounded)), validator: (value) => value == null || value.length < 8 ? 'Use at least 8 characters.' : null),
              const SizedBox(height: 14),
              TextFormField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.verified_user_outlined)), validator: (value) => value != _password.text ? 'Passwords do not match.' : null),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: auth.isLoading ? null : _signup, child: auth.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Create account'))),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authControllerProvider.notifier).register(name: _name.text.trim(), email: _email.text.trim(), password: _password.text);
  }
}
