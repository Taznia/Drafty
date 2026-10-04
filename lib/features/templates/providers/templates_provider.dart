import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../models/cv_template.dart';

final templatesProvider = Provider<List<CvTemplate>>((ref) {
  return const [
    CvTemplate(id: 'sora', name: 'Sora', description: 'Warm, confident and easy to scan.', category: 'Modern', color: Color(0xFF18242B), accent: Color(0xFF9BD7C4), style: TemplateStyle.editorial, isAtsFriendly: true),
    CvTemplate(id: 'atlas', name: 'Atlas', description: 'Structured for sharp career stories.', category: 'Corporate', color: Color(0xFF274C77), accent: Color(0xFFF4C95D), style: TemplateStyle.structured),
    CvTemplate(id: 'mono', name: 'Mono', description: 'Quietly distinctive with clean rhythm.', category: 'Minimal', color: Color(0xFF303030), accent: Color(0xFFE6856B), style: TemplateStyle.minimal, isAtsFriendly: true),
    CvTemplate(id: 'lumen', name: 'Lumen', description: 'A bright canvas for creative roles.', category: 'Creative', color: Color(0xFFF5EFE6), accent: Color(0xFFB75D3B), style: TemplateStyle.creative, isPremium: true),
    CvTemplate(id: 'northstar', name: 'Northstar', description: 'Executive clarity with a confident header.', category: 'Executive', color: Color(0xFF202A44), accent: Color(0xFF8DB5FF), style: TemplateStyle.academic, isPremium: true),
    CvTemplate(id: 'signal', name: 'Signal', description: 'Tech-forward hierarchy for impact-led roles.', category: 'Tech', color: Color(0xFF102A2A), accent: Color(0xFF4FE0B6), style: TemplateStyle.compact, isAtsFriendly: true),
    CvTemplate(id: 'brief', name: 'Brief', description: 'Compact, readable and recruiter-friendly.', category: 'ATS-friendly', color: Color(0xFF252525), accent: Color(0xFFB0B0B0), style: TemplateStyle.compact, isAtsFriendly: true),
    CvTemplate(id: 'scholar', name: 'Scholar', description: 'Measured typography for academic careers.', category: 'Academic', color: Color(0xFF3D2B24), accent: Color(0xFFC79C6E), style: TemplateStyle.academic),
    CvTemplate(id: 'forge', name: 'Forge', description: 'Bold two-column energy for makers.', category: 'Two-column', color: Color(0xFF3A1F32), accent: Color(0xFFF07AA7), style: TemplateStyle.creative, isPremium: true),
    CvTemplate(id: 'faangline', name: 'Faangline', description: 'Original impact-first structure for product teams.', category: 'FAANG-style', color: Color(0xFF161616), accent: Color(0xFF6BD5FF), style: TemplateStyle.faang, isAtsFriendly: true),
  ];
});