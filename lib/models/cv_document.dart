class CvDocument {
  const CvDocument({
    required this.title,
    required this.role,
    required this.updated,
    required this.completion,
    required this.template,
    this.isFeatured = false,
  });

  final String title;
  final String role;
  final String updated;
  final double completion;
  final String template;
  final bool isFeatured;
}