import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/premium_access.dart';

final premiumAccessProvider = Provider<PremiumAccess>((ref) => const PremiumAccess.free());