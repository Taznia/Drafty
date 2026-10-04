import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draftly Premium')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.workspace_premium_rounded, color: AppColors.mint, size: 32),
              const SizedBox(height: 20),
              Text('Make more room for what is next.', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text('Unlock the full toolkit for a CV that keeps evolving with you.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFFB7C6C1))),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Premium includes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const _FeatureRow(icon: Icons.palette_outlined, text: 'Every premium template'),
          const _FeatureRow(icon: Icons.auto_awesome_outlined, text: 'Advanced customization'),
          const _FeatureRow(icon: Icons.analytics_outlined, text: 'ATS and CV improvement tools'),
          const _FeatureRow(icon: Icons.all_inclusive_rounded, text: 'Unlimited CV versions'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Premium billing is being connected next.'))),
            icon: const Icon(Icons.lock_open_rounded),
            label: const Text('Unlock Premium'),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: AppColors.mint.withValues(alpha: .3), foregroundColor: AppColors.mintDeep, child: Icon(icon)),
      title: Text(text),
    );
  }
}