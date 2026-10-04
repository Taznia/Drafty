import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/cv_template.dart';
import '../../premium/presentation/premium_screen.dart';
import '../../premium/providers/premium_provider.dart';
import '../../preview/presentation/cv_preview_screen.dart';
import '../providers/templates_provider.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templatesProvider);
    final access = ref.watch(premiumAccessProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Template library')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 4), sliver: SliverToBoxAdapter(child: Text('Find your visual voice.', style: Theme.of(context).textTheme.displaySmall))),
          SliverPadding(padding: const EdgeInsets.fromLTRB(20, 6, 20, 20), sliver: SliverToBoxAdapter(child: Text('Every template is designed to keep your story in focus.', style: Theme.of(context).textTheme.bodyMedium))),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 230, mainAxisExtent: 320, crossAxisSpacing: 14, mainAxisSpacing: 14),
              itemCount: templates.length,
              itemBuilder: (context, index) => _TemplateCard(template: templates[index], isLocked: templates[index].isPremium && !access.isPremium),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.isLocked});

  final CvTemplate template;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => isLocked ? const PremiumScreen() : CvPreviewScreen(template: template))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Center(child: CvTemplatePreview(template: template))),
            const SizedBox(height: 10),
            Row(children: [Expanded(child: Text(template.name, style: Theme.of(context).textTheme.titleMedium)), if (template.isPremium) Icon(isLocked ? Icons.lock_outline_rounded : Icons.workspace_premium_outlined, size: 18, color: AppColors.mintDeep)]),
            const SizedBox(height: 3),
            Row(children: [Expanded(child: Text(template.category, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11, color: AppColors.coralSoft))), if (template.isAtsFriendly) const Text('ATS', style: TextStyle(color: AppColors.mint, fontSize: 10, fontWeight: FontWeight.w800))]),
            const SizedBox(height: 2),
            Text(template.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}