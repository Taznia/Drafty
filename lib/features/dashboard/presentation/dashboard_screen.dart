import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/cv_document.dart';
import '../../cv_editor/presentation/cv_editor_screen.dart';
import '../../templates/presentation/templates_screen.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(cvDocumentsProvider);
    final query = ref.watch(dashboardSearchProvider).trim().toLowerCase();
    final filtered = documents.where((cv) => cv.title.toLowerCase().contains(query) || cv.role.toLowerCase().contains(query)).toList();
    final averageCompletion = documents.isEmpty ? 0.0 : documents.map((cv) => cv.completion).reduce((total, value) => total + value) / documents.length;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), sliver: SliverToBoxAdapter(child: _Header(onNotifications: () {}))),
            SliverPadding(padding: const EdgeInsets.fromLTRB(20, 28, 20, 0), sliver: SliverToBoxAdapter(child: _WelcomeHero(onCreate: () => _openEditor(context)))),
            SliverPadding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), sliver: SliverToBoxAdapter(child: _ProgressSnapshot(completion: averageCompletion, count: documents.length))),
            SliverPadding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 12), sliver: SliverToBoxAdapter(child: _SectionHeading(title: 'Recent CVs', actionLabel: 'See all', onAction: () {}))),
            SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 20), sliver: SliverToBoxAdapter(child: TextField(onChanged: (value) => ref.read(dashboardSearchProvider.notifier).update(value), decoration: const InputDecoration(hintText: 'Search your CVs', prefixIcon: Icon(Icons.search_rounded))))),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: filtered.isEmpty ? const SliverToBoxAdapter(child: _EmptyState()) : SliverList.builder(itemCount: filtered.length, itemBuilder: (context, index) => _CvCard(document: filtered[index], onTap: () => _openEditor(context))),
            ),
            SliverPadding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 12), sliver: SliverToBoxAdapter(child: _SectionHeading(title: 'Find your format', actionLabel: 'Browse', onAction: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TemplatesScreen()))))),
            SliverPadding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 34), sliver: SliverToBoxAdapter(child: _TemplateShortcutRow(onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TemplatesScreen()))))),
          ],
        ),
      ),
    );
  }

  void _openEditor(BuildContext context) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CvEditorScreen()));
}

class _Header extends StatelessWidget {
  const _Header({required this.onNotifications});
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.auto_awesome_rounded, color: AppColors.ink)),
        const SizedBox(width: 12),
        Text('draftly', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20, letterSpacing: .4)),
        const Spacer(),
        IconButton(onPressed: onNotifications, tooltip: 'Notifications', icon: const Icon(Icons.notifications_none_rounded)),
        const SizedBox(width: 2),
        const CircleAvatar(radius: 18, backgroundColor: AppColors.line, child: Icon(Icons.person_outline_rounded, size: 20, color: AppColors.slate)),
      ]);
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 22, 18, 18),
        decoration: BoxDecoration(color: AppColors.charcoal, borderRadius: BorderRadius.circular(26), border: Border.all(color: AppColors.line)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.wb_sunny_outlined, color: AppColors.coralSoft), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.coral.withValues(alpha: .14), borderRadius: BorderRadius.circular(20)), child: const Text('YOUR WORKSPACE', style: TextStyle(color: AppColors.coralSoft, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)))]),
          const SizedBox(height: 24),
          Text('Build a CV\nworth remembering.', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontSize: 31)),
          const SizedBox(height: 10),
          Text('Make your next move feel a little more like you.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.slate)),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: onCreate, icon: const Icon(Icons.add_rounded), label: const Text('Create a new CV')),
        ]),
      );
}

class _ProgressSnapshot extends StatelessWidget {
  const _ProgressSnapshot({required this.completion, required this.count});
  final double completion;
  final int count;

  @override
  Widget build(BuildContext context) {
    final percent = (completion * 100).round();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(22)),
      child: Row(children: [
        SizedBox(width: 58, height: 58, child: Stack(fit: StackFit.expand, children: [CircularProgressIndicator(value: completion, strokeWidth: 6, backgroundColor: AppColors.ink.withValues(alpha: .14), valueColor: const AlwaysStoppedAnimation(AppColors.ink)), Center(child: Text('$percent%', style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 12)))])),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Portfolio momentum', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 4), Text('$count saved CV${count == 1 ? '' : 's'}  ·  Keep your strongest version moving.', style: const TextStyle(color: Color(0xFF6D3E37), fontSize: 12, height: 1.3))])),
        const Icon(Icons.arrow_forward_rounded, color: AppColors.ink),
      ]),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.actionLabel, required this.onAction});
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Row(children: [Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 21)), const Spacer(), TextButton(onPressed: onAction, child: Text(actionLabel))]);
}

class _CvCard extends StatelessWidget {
  const _CvCard({required this.document, required this.onTap});
  final CvDocument document;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percent = (document.completion * 100).round();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
          Container(width: 58, height: 74, decoration: BoxDecoration(color: document.isFeatured ? AppColors.coral.withValues(alpha: .22) : AppColors.line, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.description_outlined, color: document.isFeatured ? AppColors.coral : AppColors.slate, size: 28)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(document.title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(document.role, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 12), Row(children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: document.completion, minHeight: 5, backgroundColor: AppColors.line, color: AppColors.coral))), const SizedBox(width: 9), Text('$percent%', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.coralSoft, fontWeight: FontWeight.w800))]), const SizedBox(height: 6), Text(document.updated, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11))])),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.slate),
        ])),
      ),
    );
  }
}

class _TemplateShortcutRow extends StatelessWidget {
  const _TemplateShortcutRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(height: 142, child: ListView(scrollDirection: Axis.horizontal, children: [
        _ShortcutCard(label: 'Sora', detail: 'Warm + editorial', color: AppColors.coral, icon: Icons.auto_awesome_rounded, onTap: onTap),
        const SizedBox(width: 12),
        _ShortcutCard(label: 'Atlas', detail: 'Sharp + structured', color: const Color(0xFF6FA5D9), icon: Icons.view_quilt_outlined, onTap: onTap),
        const SizedBox(width: 12),
        _ShortcutCard(label: 'Mono', detail: 'Quiet + minimal', color: AppColors.mint, icon: Icons.horizontal_rule_rounded, onTap: onTap),
      ]));
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({required this.label, required this.detail, required this.color, required this.icon, required this.onTap});
  final String label;
  final String detail;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(width: 178, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withValues(alpha: .14), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: .28))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color), const Spacer(), Text(label, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 2), Text(detail, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12))]))));
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 34), child: Column(children: [const Icon(Icons.description_outlined, size: 40, color: AppColors.slate), const SizedBox(height: 12), Text('No CVs match that search', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), Text('Try another title or role.', style: Theme.of(context).textTheme.bodyMedium)]));
}
