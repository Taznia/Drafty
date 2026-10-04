import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../models/cv_template.dart';
import '../../../models/cv_draft.dart';

abstract final class CvPdfService {
  static Future<void> share({required CvTemplate template, required Map<String, String>? values, CvDraft? draft}) async {
    final bytes = await build(template: template, values: values, draft: draft).save();
    await Printing.sharePdf(bytes: bytes, filename: '${template.id}-cv.pdf');
  }

  static Future<void> print({required CvTemplate template, required Map<String, String>? values, CvDraft? draft}) async {
    await Printing.layoutPdf(onLayout: (_) => build(template: template, values: values, draft: draft).save());
  }

  static pw.Document build({required CvTemplate template, required Map<String, String>? values, CvDraft? draft}) {
    final document = pw.Document();
    final name = _value(values, draft, 'Full name', 'Alex Morgan');
    final role = _value(values, draft, 'Professional title', 'Product Designer').toUpperCase();
    final email = _value(values, draft, 'Email', 'alex@example.com');
    final location = _value(values, draft, 'Location', 'London, UK');
    final summary = _value(values, draft, 'Summary', 'A thoughtful designer who turns complex problems into clear, useful experiences.');
    final experience = _value(values, draft, 'What did you achieve?', 'Led product experiences from first sketch to shipped detail.');
    final education = _value(values, draft, 'School', 'Education and qualifications');
    final skills = _value(values, draft, 'Skills', 'Product strategy, Figma, Research, Prototyping').split(',').map((skill) => skill.trim()).where((skill) => skill.isNotEmpty).toList();
    final sections = draft?.sections ?? const <CvSection>[];
    final ink = PdfColor.fromInt(template.color.toARGB32());
    final accent = PdfColor.fromInt(template.accent.toARGB32());
    final paper = template.style == TemplateStyle.editorial ? PdfColor.fromInt(0xFFFFFDF8) : PdfColors.white;

    document.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) => pw.Container(
        color: paper,
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
          if (template.style == TemplateStyle.structured || template.style == TemplateStyle.creative || template.style == TemplateStyle.faang) pw.Container(width: 118, color: ink),
          pw.Expanded(child: pw.Padding(padding: const pw.EdgeInsets.all(46), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            if (template.style == TemplateStyle.editorial || template.style == TemplateStyle.creative || template.style == TemplateStyle.faang) pw.Container(height: 10, width: 84, color: accent),
            pw.SizedBox(height: 18),
            pw.Text(name, style: pw.TextStyle(color: ink, fontSize: 28, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Text(role, style: pw.TextStyle(color: accent, fontSize: 11, fontWeight: pw.FontWeight.bold, letterSpacing: 1.3)),
            pw.SizedBox(height: 10),
            pw.Text('$email  |  $location', style: pw.TextStyle(color: ink, fontSize: 9)),
            pw.SizedBox(height: 30),
            if (sections.isEmpty) ...[
              _section('PROFILE', summary, ink, accent),
              pw.SizedBox(height: 22),
              _section('EXPERIENCE', experience, ink, accent),
              pw.SizedBox(height: 22),
              _section('EDUCATION', education, ink, accent),
              pw.SizedBox(height: 22),
              _skills(skills, ink, accent),
            ],
            if (sections.isNotEmpty) ...sections.where((section) => section.type != CvSectionType.personal).map((section) => _sectionFromDraft(section, ink, accent)),
          ]))),
        ]),
      ),
    ));
    return document;
  }

  static pw.Widget _section(String heading, String body, PdfColor ink, PdfColor accent) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(heading, style: pw.TextStyle(color: ink, fontSize: 10, fontWeight: pw.FontWeight.bold, letterSpacing: .8)),
      pw.SizedBox(height: 9),
      pw.Container(height: 2, width: 34, color: accent),
      pw.SizedBox(height: 9),
      pw.Text(body, style: pw.TextStyle(color: ink, fontSize: 10, lineSpacing: 3)),
    ]);
  }

  static pw.Widget _skills(List<String> skills, PdfColor ink, PdfColor accent) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Text('SELECTED SKILLS', style: pw.TextStyle(color: ink, fontSize: 10, fontWeight: pw.FontWeight.bold, letterSpacing: .8)), pw.SizedBox(height: 9), pw.Wrap(spacing: 7, runSpacing: 7, children: skills.map((skill) => pw.Container(padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 5), color: accent.shade(0.8), child: pw.Text(skill, style: pw.TextStyle(color: ink, fontSize: 8)))).toList())]);

  static pw.Widget _sectionFromDraft(CvSection section, PdfColor ink, PdfColor accent) {
    final content = section.values.values.where((value) => value.trim().isNotEmpty).join('  |  ');
    return _section(section.title.toUpperCase(), content, ink, accent);
  }

  static String _value(Map<String, String>? values, CvDraft? draft, String key, String fallback) {
    final draftValue = draft?.sections.expand((section) => section.values.entries).firstWhere((entry) => entry.key == key, orElse: () => const MapEntry('', '')).value;
    final value = (values?[key] ?? draftValue ?? '').trim();
    return value.isEmpty ? fallback : value;
  }
}