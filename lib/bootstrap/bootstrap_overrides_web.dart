import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Purpose: Build startup overrides for web where Isar initialization is
/// intentionally skipped.
Future<List<Override>> createBootstrapOverrides() async {
  return const <Override>[];
}
