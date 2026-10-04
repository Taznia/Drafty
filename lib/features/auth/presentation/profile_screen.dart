import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_theme_controller.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).value;
    final user = session?.user;
    return SafeArea(
      child: ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 30), children: [
        Text('Your space', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 8),
        Text('Keep your account and preferences close at hand.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 26),
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(22)), child: Row(children: [const CircleAvatar(radius: 26, backgroundColor: AppColors.coral, child: Icon(Icons.person_outline_rounded, color: AppColors.ink)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(user?.name ?? 'Your account', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(user?.email ?? 'Account details', style: Theme.of(context).textTheme.bodyMedium)]))])),
        const SizedBox(height: 14),
        _ProfileRow(icon: Icons.tune_rounded, title: 'Preferences', subtitle: 'Theme, export and app settings', onTap: () => _showThemePicker(context, ref)),
        const _ProfileRow(icon: Icons.lock_outline_rounded, title: 'Privacy', subtitle: 'Your CVs stay yours'),
        const SizedBox(height: 22),
        OutlinedButton.icon(onPressed: () => _logout(context, ref), icon: const Icon(Icons.logout_rounded), label: const Text('Log out'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.coralSoft, side: const BorderSide(color: AppColors.line), padding: const EdgeInsets.symmetric(vertical: 15))),
      ]),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).logout();
  }

  Future<void> _showThemePicker(BuildContext context, WidgetRef ref) async {
    final selected = await showModalBottomSheet<AppThemeMode>(context: context, showDragHandle: true, builder: (context) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 10), child: Align(alignment: Alignment.centerLeft, child: Text('App theme', style: Theme.of(context).textTheme.headlineSmall))),
          for (final mode in AppThemeMode.values) ListTile(leading: Icon(mode == AppThemeMode.black || mode == AppThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined), title: Text(mode.name[0].toUpperCase() + mode.name.substring(1)), onTap: () => Navigator.pop(context, mode)),
          const SizedBox(height: 12),
        ])));
    if (selected != null) await ref.read(appThemeProvider.notifier).setMode(selected);
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.icon, required this.title, required this.subtitle, this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(child: ListTile(onTap: onTap, leading: CircleAvatar(backgroundColor: AppColors.coral.withValues(alpha: .14), foregroundColor: AppColors.coralSoft, child: Icon(icon)), title: Text(title), subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.slate)));
}
