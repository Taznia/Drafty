import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/cv_draft.dart';
import '../../../models/cv_template.dart';
import '../services/cv_pdf_service.dart';

class CvPreviewScreen extends StatefulWidget {
  const CvPreviewScreen({super.key, this.template, this.values, this.draft});

  final CvTemplate? template;
  final Map<String, String>? values;
  final CvDraft? draft;

  @override
  State<CvPreviewScreen> createState() => _CvPreviewScreenState();
}

class _CvPreviewScreenState extends State<CvPreviewScreen> {
  bool _isExporting = false;
  late final TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.template ?? const CvTemplate(id: 'sora', name: 'Sora', description: '', category: 'Modern', color: AppColors.ink, accent: AppColors.mint, style: TemplateStyle.editorial);
    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        title: Text('${selected.name} preview'),
        actions: [
          IconButton(onPressed: _resetZoom, tooltip: 'Fit to screen', icon: const Icon(Icons.fit_screen_rounded)),
          IconButton(onPressed: _zoomOut, tooltip: 'Zoom out', icon: const Icon(Icons.zoom_out_rounded)),
          IconButton(onPressed: _zoomIn, tooltip: 'Zoom in', icon: const Icon(Icons.zoom_in_rounded)),
        ],
      ),
      body: Column(children: [
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          final pageWidth = (constraints.maxWidth * .9).clamp(280.0, 560.0);
          return InteractiveViewer(
            transformationController: _transformationController,
            minScale: .55,
            maxScale: 3,
            boundaryMargin: const EdgeInsets.all(120),
            child: Center(child: CvTemplatePreview(template: selected, values: widget.values, draft: widget.draft, fullSize: true, width: pageWidth, height: pageWidth * 1.414)),
          );
        })),
        Container(padding: const EdgeInsets.fromLTRB(18, 10, 18, 12), color: AppColors.charcoal, child: SafeArea(top: false, child: Row(children: [
          Text('Page 1 of 1', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          const Spacer(),
          TextButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.edit_outlined), label: const Text('Edit')),
          const SizedBox(width: 6),
          FilledButton.icon(onPressed: _isExporting ? null : () => _share(selected), icon: const Icon(Icons.ios_share_rounded), label: const Text('Share')),
          const SizedBox(width: 6),
          IconButton(onPressed: _isExporting ? null : () => _print(selected), tooltip: 'Print or download', icon: const Icon(Icons.download_outlined, color: Colors.white)),
        ]))),
      ]),
    );
  }

  void _zoomIn() => _transformationController.value = _transformationController.value.scaledByDouble(1.2, 1.2, 1.2, 1);
  void _zoomOut() => _transformationController.value = _transformationController.value.scaledByDouble(.8, .8, .8, 1);
  void _resetZoom() => _transformationController.value = Matrix4.identity();

  Future<void> _share(CvTemplate template) async {
    await _runExport(() => CvPdfService.share(template: template, values: widget.values, draft: widget.draft));
  }

  Future<void> _print(CvTemplate template) async {
    await _runExport(() => CvPdfService.print(template: template, values: widget.values, draft: widget.draft));
  }

  Future<void> _runExport(Future<void> Function() export) async {
    setState(() => _isExporting = true);
    try {
      await export();
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $error')));
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}

class CvTemplatePreview extends StatelessWidget {
  const CvTemplatePreview({super.key, required this.template, this.values, this.draft, this.fullSize = false, this.width, this.height});

  final CvTemplate template;
  final Map<String, String>? values;
  final CvDraft? draft;
  final bool fullSize;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final previewWidth = width ?? (fullSize ? 340.0 : 150.0);
    final previewHeight = height ?? (fullSize ? 460.0 : 205.0);
    final compact = !fullSize;
    final titleSize = compact ? 9.0 : 19.0;
    final bodySize = compact ? 4.0 : 8.0;
    final sectionSize = compact ? 5.0 : 10.0;
    final hasSidebar = template.style == TemplateStyle.structured || template.style == TemplateStyle.creative || template.style == TemplateStyle.faang;
    final hasTopBar = template.style == TemplateStyle.editorial || template.style == TemplateStyle.creative || template.style == TemplateStyle.faang;
    final name = _value('Full name', 'Alex Morgan');
    final role = _value('Professional title', 'Product Designer').toUpperCase();
    final sections = draft?.sections ?? const <CvSection>[];

    return Container(
      width: previewWidth,
      height: previewHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: template.style == TemplateStyle.editorial ? const Color(0xFFFFFDF8) : Colors.white, borderRadius: BorderRadius.circular(compact ? 10 : 4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .14), blurRadius: compact ? 8 : 20, offset: const Offset(0, 8))]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasSidebar) Container(width: compact ? 34 : 78, color: template.color),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(compact ? 12 : 26),
              child: SingleChildScrollView(physics: compact ? const NeverScrollableScrollPhysics() : null, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (hasTopBar) Container(height: compact ? 4 : 8, width: compact ? 30 : 72, color: template.accent),
                SizedBox(height: compact ? 7 : 14),
                if (draft?.photoPath != null && (template.style == TemplateStyle.creative || template.style == TemplateStyle.academic)) Padding(padding: EdgeInsets.only(bottom: compact ? 6 : 12), child: CircleAvatar(radius: compact ? 13 : 30, backgroundImage: FileImage(File(draft!.photoPath!)))),
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: template.color, fontWeight: FontWeight.w800, fontSize: titleSize)),
                SizedBox(height: compact ? 2 : 5),
                Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: template.accent, fontWeight: FontWeight.w700, fontSize: bodySize, letterSpacing: 1)),
                SizedBox(height: compact ? 10 : 24),
                if (sections.isEmpty) ..._fallbackSections(template, bodySize, sectionSize, compact),
                if (sections.isNotEmpty) ...sections.where((section) => section.type != CvSectionType.personal).map((section) => _sectionWidget(section, template, bodySize, sectionSize, compact)),
              ])),
            ),
          ),
        ],
      ),
    );
  }

  String _value(String key, String fallback) {
    final value = values?[key] ?? draft?.sections.expand((section) => section.values.entries).firstWhere((entry) => entry.key == key, orElse: () => const MapEntry('', '')).value;
    return value?.trim().isNotEmpty == true ? value!.trim() : fallback;
  }

  List<Widget> _fallbackSections(CvTemplate template, double bodySize, double sectionSize, bool compact) => [
        Text(_value('Summary', 'A thoughtful designer who turns complex problems into clear, useful experiences.'), maxLines: compact ? 3 : 4, overflow: TextOverflow.ellipsis, style: TextStyle(color: template.color.withValues(alpha: .65), fontSize: bodySize, height: 1.2)),
        SizedBox(height: compact ? 10 : 22),
        _sectionWidget(CvSection(id: 'experience', type: CvSectionType.experience, title: 'Experience', fields: const [], values: {'Details': _value('What did you achieve?', 'Led product experiences from first sketch to shipped detail.')}), template, bodySize, sectionSize, compact),
        SizedBox(height: compact ? 8 : 18),
        _sectionWidget(CvSection(id: 'skills', type: CvSectionType.skills, title: 'Selected skills', fields: const [], values: {'Skills': _value('Skills', 'Product strategy, Figma, Research, Prototyping')}), template, bodySize, sectionSize, compact),
      ];

  Widget _sectionWidget(CvSection section, CvTemplate template, double bodySize, double sectionSize, bool compact) {
    final content = section.values.values.where((value) => value.trim().isNotEmpty).join('  ·  ');
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(padding: EdgeInsets.only(bottom: compact ? 8 : 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(section.title.toUpperCase(), style: TextStyle(color: template.color, fontWeight: FontWeight.w800, fontSize: sectionSize, letterSpacing: .8)), SizedBox(height: compact ? 5 : 10), Text(content, maxLines: compact ? 3 : 8, overflow: TextOverflow.ellipsis, style: TextStyle(color: template.color.withValues(alpha: .65), fontSize: bodySize, height: 1.2))]));
  }
}

