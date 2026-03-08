/// Purpose: Represent user-visible feedback with a stable tone for the safety
/// plan flow.
class SafetyUiMessage {
  const SafetyUiMessage({required this.text, required this.isError});

  final String text;
  final bool isError;
}
