import 'package:flutter/material.dart';

enum TemplateStyle { editorial, structured, minimal, compact, academic, creative, faang }

class CvTemplate {
  const CvTemplate({required this.id, required this.name, required this.description, required this.category, required this.color, required this.accent, required this.style, this.isPremium = false, this.isAtsFriendly = false});

  final String id;
  final String name;
  final String description;
  final String category;
  final Color color;
  final Color accent;
  final TemplateStyle style;
  final bool isPremium;
  final bool isAtsFriendly;
}