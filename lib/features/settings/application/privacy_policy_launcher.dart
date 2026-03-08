import 'package:url_launcher/url_launcher.dart';
import 'package:vibemental_app/core/config/legal_document_config.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/platform/url_launcher_gateway.dart';

/// Purpose: Abstract privacy-policy launching so settings UI stays testable and
/// independent from platform URL-launching details.
abstract class PrivacyPolicyLauncher {
  /// Purpose: Open the configured privacy-policy page in an external browser.
  Future<bool> openPrivacyPolicy();
}

/// Purpose: Launch a validated external privacy-policy URL.
class ExternalPrivacyPolicyLauncher implements PrivacyPolicyLauncher {
  ExternalPrivacyPolicyLauncher({
    required String privacyPolicyUrl,
    required AppLogger logger,
    required UrlLauncherGateway launcher,
  }) : _privacyPolicyUrl = privacyPolicyUrl,
       _logger = logger,
       _launcher = launcher;

  final String _privacyPolicyUrl;
  final AppLogger _logger;
  final UrlLauncherGateway _launcher;

  @override
  Future<bool> openPrivacyPolicy() async {
    final uri = _buildPrivacyPolicyUri();
    if (uri == null) {
      _logger.warn(
        'Privacy policy URL is invalid.',
        context: {'action': 'privacy_policy'},
      );
      return false;
    }

    try {
      final launched = await _launcher.launch(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _logger.warn(
          'Failed to launch privacy policy URL.',
          context: {'action': 'privacy_policy'},
        );
      }
      return launched;
    } catch (error, stackTrace) {
      _logger.error(
        'Privacy policy launch threw an exception.',
        error: error,
        stackTrace: stackTrace,
        context: {'action': 'privacy_policy'},
      );
      return false;
    }
  }

  /// Purpose: Parse and validate the configured privacy-policy URL before
  /// delegating to the platform launcher.
  Uri? _buildPrivacyPolicyUri() {
    final uri = Uri.tryParse(_privacyPolicyUrl);
    if (uri == null || uri.host.isEmpty) {
      return null;
    }

    if (!LegalDocumentConfig.allowedSchemes.contains(uri.scheme)) {
      return null;
    }

    return uri;
  }
}
