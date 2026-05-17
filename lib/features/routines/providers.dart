// lib/features/routines/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../providers.dart';

final routinesProvider = StreamProvider<List<Routine>>((ref) {
  return ref.watch(databaseProvider).routinesDao.watchAll();
});
