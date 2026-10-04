import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/cv_draft.dart';
import '../../../models/cv_template.dart';
import '../../preview/presentation/cv_preview_screen.dart';
import '../../templates/providers/templates_provider.dart';
import '../services/cv_api_service.dart';

class CvEditorScreen extends ConsumerStatefulWidget {
  const CvEditorScreen({super.key});

  @override
  ConsumerState<CvEditorScreen> createState() => _CvEditorScreenState();
}

class _CvEditorScreenState extends ConsumerState<CvEditorScreen> {
  late final List<CvSection> _sections;
  late CvTemplate _selectedTemplate;
  final Map<String, TextEditingController> _controllers = {};
  int _nextSectionId = 0;
  bool _isSaving = false;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = ref.read(templatesProvider).first;
    _sections = [
      _section(CvSectionType.personal, 'Personal information', ['Full name', 'Professional title', 'Email', 'Location', 'Portfolio URL', 'LinkedIn URL', 'GitHub URL']),
      _section(CvSectionType.summary, 'Professional summary', ['Summary']),
      _section(CvSectionType.experience, 'Experience', ['Role', 'Company', 'Dates', 'What did you achieve?']),
      _section(CvSectionType.education, 'Education', ['School', 'Degree or course', 'Year']),
      _section(CvSectionType.skills, 'Skills', ['Skills']),
    ];
  }

  CvSection _section(CvSectionType type, String title, List<String> fields) => CvSection(id: '${type.name}-${_nextSectionId++}', type: type, title: title, fields: fields);

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  CvDraft get _draft => CvDraft(title: 'New CV', templateId: _selectedTemplate.id, sections: _sections, photoPath: _photoPath, links: _linksFromSections());

  Map<String, String> _linksFromSections() => {
        for (final entry in _sections.expand((section) => section.values.entries))
          if (entry.key.endsWith('URL') && entry.value.trim().isNotEmpty) entry.key: entry.value.trim(),
      };

  TextEditingController _controllerFor(CvSection section, String field) {
    final key = '${section.id}.$field';
    return _controllers.putIfAbsent(key, () => TextEditingController(text: section.values[field] ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final completion = _draft.completion;
    final percent = (completion * 100).round();
    return Scaffold(
      appBar: AppBar(
        title: const Text('New CV'),
        actions: [
          IconButton(onPressed: () => _openPreview(context), tooltip: 'Preview CV', icon: const Icon(Icons.visibility_outlined)),
          IconButton(onPressed: _showTemplatePicker, tooltip: 'Change template', icon: const Icon(Icons.palette_outlined)),
          IconButton(onPressed: _isSaving ? null : _saveDraft, tooltip: 'Save draft', icon: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check_rounded)),
        ],
      ),
      body: Column(children: [
        _ProgressHeader(percent: percent, completion: completion),
        _TemplateBar(template: _selectedTemplate, onTap: _showTemplatePicker),
        _PhotoBar(photoPath: _photoPath, onPick: _pickPhoto, onRemove: _photoPath == null ? null : _removePhoto),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
            itemCount: _sections.length,
            onReorderItem: _reorder,
            itemBuilder: (context, index) {
              final section = _sections[index];
              return _SectionCard(
                key: ValueKey(section.id),
                index: index,
                section: section,
                icon: _sectionIcon(section.type),
                controllerFor: _controllerFor,
                onChanged: (field, value) => setState(() => section.values[field] = value),
                onRemove: section.type == CvSectionType.personal ? null : () => _removeSection(section),
              );
            },
          ),
        ),
        SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 12), child: OutlinedButton.icon(onPressed: _showAddSection, icon: const Icon(Icons.add_rounded), label: const Text('Add another section'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), side: const BorderSide(color: AppColors.line))))),
      ]),
    );
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      final section = _sections.removeAt(oldIndex);
      _sections.insert(newIndex, section);
    });
  }

  void _removeSection(CvSection section) => setState(() => _sections.remove(section));

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1200, imageQuality: 82);
    if (!mounted || picked == null) return;
    setState(() => _photoPath = picked.path);
  }

  void _removePhoto() => setState(() => _photoPath = null);

  Future<void> _showTemplatePicker() async {
    final templates = ref.read(templatesProvider);
    final selected = await showModalBottomSheet<CvTemplate>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), children: [
        Text('Change template', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text('Your sections and content stay exactly as they are.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        ...templates.map((template) => ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
              leading: _MiniTemplatePreview(template: template),
              title: Text(template.name),
              subtitle: Text(template.description),
              trailing: template.id == _selectedTemplate.id ? const Icon(Icons.check_circle_rounded, color: AppColors.coral) : const Icon(Icons.chevron_right_rounded),
              onTap: template.isPremium ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Premium template access is required.'))) : () => Navigator.pop(context, template),
            )),
      ])),
    );
    if (!mounted || selected == null) return;
    setState(() => _selectedTemplate = selected);
  }

  Future<void> _showAddSection() async {
    final existing = _sections.map((section) => section.type).toSet();
    final available = _sectionOptions.where((option) => option.type == CvSectionType.custom || !existing.contains(option.type)).toList();
    final option = await showModalBottomSheet<_SectionOption>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), children: [
        Text('Add a section', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Every section you add is included in preview and export.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        ...available.map((item) => ListTile(leading: CircleAvatar(backgroundColor: AppColors.mint.withValues(alpha: .35), foregroundColor: AppColors.mintDeep, child: Icon(_sectionIcon(item.type))), title: Text(item.title), trailing: const Icon(Icons.add_rounded), onTap: () => Navigator.pop(context, item))),
      ])),
    );
    if (!mounted || option == null) return;
    var title = option.title;
    if (option.type == CvSectionType.custom) {
      final customTitle = await _askForCustomTitle();
      if (!mounted || customTitle == null || customTitle.trim().isEmpty) return;
      title = customTitle.trim();
    }
    setState(() => _sections.add(_section(option.type, title, option.fields)));
  }

  Future<String?> _askForCustomTitle() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(context: context, builder: (context) => AlertDialog(title: const Text('Name your section'), content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Section title')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Add'))]));
    controller.dispose();
    return title;
  }

  Future<void> _saveDraft() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isSaving = true);
    try {
      await ref.read(cvApiServiceProvider).create(_draft);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Draft saved with ${_sections.length} sections.')));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save draft: $error')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _openPreview(BuildContext context) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => CvPreviewScreen(template: _selectedTemplate, draft: _draft)));
}

IconData _sectionIcon(CvSectionType type) {
  switch (type) {
    case CvSectionType.personal: return Icons.person_outline_rounded;
    case CvSectionType.summary: return Icons.notes_rounded;
    case CvSectionType.experience: return Icons.work_outline_rounded;
    case CvSectionType.education: return Icons.school_outlined;
    case CvSectionType.skills: return Icons.bolt_outlined;
    case CvSectionType.projects: return Icons.rocket_launch_outlined;
    case CvSectionType.certifications: return Icons.workspace_premium_outlined;
    case CvSectionType.languages: return Icons.translate_rounded;
    case CvSectionType.references: return Icons.groups_outlined;
    case CvSectionType.awards: return Icons.emoji_events_outlined;
    case CvSectionType.interests: return Icons.interests_outlined;
    case CvSectionType.custom: return Icons.add_box_outlined;
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.percent, required this.completion});
  final int percent;
  final double completion;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(18)),
        child: Row(children: [
          SizedBox(width: 52, height: 52, child: Stack(fit: StackFit.expand, children: [
            CircularProgressIndicator(value: completion, strokeWidth: 5, backgroundColor: Colors.white.withValues(alpha: .15), valueColor: const AlwaysStoppedAnimation(AppColors.mint)),
            Center(child: Text('$percent%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12))),
          ])),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('CV strength', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 3),
            Text(percent >= 80 ? 'Ready to make an impression.' : 'A little more detail will make it stronger.', style: const TextStyle(color: Color(0xFFB7C6C1), fontSize: 13)),
          ])),
        ]),
      );
}

class _TemplateBar extends StatelessWidget {
  const _TemplateBar({required this.template, required this.onTap});

  final CvTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
            child: Row(children: [
              _MiniTemplatePreview(template: template),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('TEMPLATE', style: TextStyle(color: AppColors.slate, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(template.name, style: Theme.of(context).textTheme.titleMedium),
              ])),
              const Icon(Icons.swap_horiz_rounded, color: AppColors.coral),
            ]),
          ),
        ),
      );
}

class _MiniTemplatePreview extends StatelessWidget {
  const _MiniTemplatePreview({required this.template});

  final CvTemplate template;

  @override
  Widget build(BuildContext context) => SizedBox(width: 42, height: 58, child: FittedBox(fit: BoxFit.contain, child: CvTemplatePreview(template: template)));
}

class _PhotoBar extends StatelessWidget {
  const _PhotoBar({required this.photoPath, required this.onPick, required this.onRemove});

  final String? photoPath;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(20, 4, 20, 2), child: Row(children: [
        CircleAvatar(radius: 18, backgroundImage: photoPath == null ? null : FileImage(File(photoPath!)), child: photoPath == null ? const Icon(Icons.person_outline_rounded, size: 19) : null),
        const SizedBox(width: 10),
        Expanded(child: Text(photoPath == null ? 'Add a profile photo' : 'Profile photo added', style: Theme.of(context).textTheme.bodyMedium)),
        if (onRemove != null) IconButton(onPressed: onRemove, tooltip: 'Remove photo', icon: const Icon(Icons.close_rounded, size: 19)),
        TextButton.icon(onPressed: onPick, icon: const Icon(Icons.add_a_photo_outlined, size: 18), label: Text(photoPath == null ? 'Add' : 'Change')),
      ]));
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({super.key, required this.index, required this.section, required this.icon, required this.controllerFor, required this.onChanged, required this.onRemove});
  final int index;
  final CvSection section;
  final IconData icon;
  final TextEditingController Function(CvSection section, String field) controllerFor;
  final void Function(String field, String value) onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ExpansionTile(
          initiallyExpanded: section.type == CvSectionType.personal,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: CircleAvatar(backgroundColor: AppColors.mint.withValues(alpha: .35), foregroundColor: AppColors.mintDeep, child: Icon(icon)),
          title: Text(section.title),
          subtitle: Text(section.isComplete ? 'Complete' : '${(section.completion * 100).round()}% complete'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [if (onRemove != null) IconButton(onPressed: onRemove, tooltip: 'Remove section', icon: const Icon(Icons.delete_outline_rounded)), ReorderableDragStartListener(index: index, child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.drag_handle_rounded)))]),
          children: section.fields.map((field) => _field(context, field)).toList(),
        ),
      );

  Widget _field(BuildContext context, String field) {
    final isLong = field == 'Summary' || field == 'What did you achieve?' || field == 'Description' || field == 'Details';
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controllerFor(section, field),
        onChanged: (value) => onChanged(field, value),
        minLines: isLong ? 4 : 1,
        maxLines: isLong ? 6 : 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: field, hintText: _hintFor(field)),
      ),
    );
  }

  String _hintFor(String field) {
    switch (field) {
      case 'Full name': return 'e.g. Alex Morgan';
      case 'Professional title': return 'e.g. Product Designer';
      case 'Summary': return 'A concise introduction that sounds like you';
      case 'Skills': return 'Separate skills with commas';
      default: return '';
    }
  }
}

class _SectionOption {
  const _SectionOption(this.type, this.title, this.fields);
  final CvSectionType type;
  final String title;
  final List<String> fields;
}

const _sectionOptions = [
  _SectionOption(CvSectionType.experience, 'Experience', ['Role', 'Company', 'Dates', 'What did you achieve?']),
  _SectionOption(CvSectionType.education, 'Education', ['School', 'Degree or course', 'Year']),
  _SectionOption(CvSectionType.skills, 'Skills', ['Skills']),
  _SectionOption(CvSectionType.projects, 'Projects', ['Project name', 'Description', 'Technologies', 'Project URL', 'GitHub URL']),
  _SectionOption(CvSectionType.certifications, 'Certifications', ['Certification', 'Issuer', 'Year']),
  _SectionOption(CvSectionType.languages, 'Languages', ['Language', 'Level']),
  _SectionOption(CvSectionType.references, 'References', ['Name', 'Role and company', 'Contact']),
  _SectionOption(CvSectionType.awards, 'Awards', ['Award', 'Issuer', 'Year']),
  _SectionOption(CvSectionType.interests, 'Interests', ['Interests']),
  _SectionOption(CvSectionType.custom, 'Custom section', ['Details']),
];
