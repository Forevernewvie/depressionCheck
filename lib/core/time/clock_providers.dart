import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/time/clock.dart';

/// Purpose: Provide shared wall-clock access so features can depend on the
/// Clock abstraction instead of the system clock directly.
final clockProvider = Provider<Clock>((ref) {
  return const SystemClock();
});
