/// Purpose: Centralize legal-document launch constraints to avoid hardcoded
/// schemes or path assumptions in presentation code.
class LegalDocumentConfig {
  LegalDocumentConfig._();

  /// Purpose: Restrict legal-document links to secure HTTPS endpoints.
  static const Set<String> allowedSchemes = <String>{'https'};
}
