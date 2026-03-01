/// Purpose: Build deterministic local date key used for one-entry-per-day
/// persistence.
String buildLocalDateKey(DateTime dateTime) {
  final local = dateTime.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}
