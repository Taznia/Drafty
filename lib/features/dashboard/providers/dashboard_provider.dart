import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/cv_document.dart';

final cvDocumentsProvider = Provider<List<CvDocument>>((ref) {
  return const [
    CvDocument(
      title: 'Product Designer CV',
      role: 'Product Designer',
      updated: 'Updated today',
      completion: .82,
      template: 'Sora',
      isFeatured: true,
    ),
    CvDocument(
      title: 'Strategy & Growth',
      role: 'Growth Strategist',
      updated: 'Updated 3 days ago',
      completion: .58,
      template: 'Atlas',
    ),
    CvDocument(
      title: 'The clean one',
      role: 'UX Researcher',
      updated: 'Updated 12 May',
      completion: .34,
      template: 'Mono',
    ),
  ];
});

class DashboardSearch extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

final dashboardSearchProvider = NotifierProvider<DashboardSearch, String>(DashboardSearch.new);