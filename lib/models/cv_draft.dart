enum CvSectionType { personal, summary, experience, education, skills, projects, certifications, languages, references, awards, interests, custom }

class CvSection {
  CvSection({required this.id, required this.type, required this.title, required this.fields, Map<String, String>? values}) : values = values ?? {};

  final String id;
  final CvSectionType type;
  String title;
  final List<String> fields;
  final Map<String, String> values;

  bool get isComplete => fields.isNotEmpty && fields.every((field) => values[field]?.trim().isNotEmpty == true);
  double get completion => fields.isEmpty ? 0 : fields.where((field) => values[field]?.trim().isNotEmpty == true).length / fields.length;

  Map<String, dynamic> toJson(int order) => {
        'type': type.name,
        'title': title,
        'data': Map<String, String>.from(values),
        'order': order,
      };
}

class CvDraft {
  CvDraft({required this.title, required this.templateId, required this.sections, this.photoPath, Map<String, String>? links}) : links = links ?? {};

  final String title;
  final String templateId;
  final List<CvSection> sections;
  final String? photoPath;
  final Map<String, String> links;

  double get completion {
    if (sections.isEmpty) return 0;
    return sections.map((section) => section.completion).reduce((total, value) => total + value) / sections.length;
  }

  Map<String, dynamic> toApiPayload() => {
        'title': title,
        'templateId': templateId,
        'links': Map<String, String>.from(links),
        if (photoPath != null) 'profilePhotoUrl': photoPath,
        'completion': completion,
        'sections': [for (var index = 0; index < sections.length; index++) sections[index].toJson(index)],
      };
}
