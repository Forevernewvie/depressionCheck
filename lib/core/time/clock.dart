/// Purpose: Abstract current-time access so domain/data code stays testable
/// without relying on system clock state.
abstract class Clock {
  /// Purpose: Return the current wall-clock timestamp.
  DateTime now();
}

/// Purpose: Provide production clock backed by system time.
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() {
    return DateTime.now();
  }
}
