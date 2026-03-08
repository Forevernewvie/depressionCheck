import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibemental_app/features/settings/application/privacy_policy_launcher.dart';
import 'package:vibemental_app/core/platform/url_launcher_gateway.dart';

import '../../fakes/test_app_logger.dart';

void main() {
  group('ExternalPrivacyPolicyLauncher', () {
    late _FakeUrlLauncherGateway launcher;
    late TestAppLogger logger;

    setUp(() {
      launcher = _FakeUrlLauncherGateway();
      logger = TestAppLogger();
    });

    test('opens GitHub Pages URL in external application mode', () async {
      final service = ExternalPrivacyPolicyLauncher(
        privacyPolicyUrl:
            'https://forevernewvie.github.io/depressionCheck/privacy-policy/',
        logger: logger,
        launcher: launcher,
      );

      final opened = await service.openPrivacyPolicy();

      expect(opened, isTrue);
      expect(launcher.lastUri, isNotNull);
      expect(launcher.lastUri!.host, 'forevernewvie.github.io');
      expect(launcher.lastMode, LaunchMode.externalApplication);
    });

    test('rejects non-https privacy policy URL', () async {
      final service = ExternalPrivacyPolicyLauncher(
        privacyPolicyUrl: 'http://example.com/privacy',
        logger: logger,
        launcher: launcher,
      );

      final opened = await service.openPrivacyPolicy();

      expect(opened, isFalse);
      expect(launcher.launchCount, 0);
      expect(logger.warnings, isNotEmpty);
    });

    test('returns false when launcher cannot open the page', () async {
      launcher.nextResult = false;
      final service = ExternalPrivacyPolicyLauncher(
        privacyPolicyUrl:
            'https://forevernewvie.github.io/depressionCheck/privacy-policy/',
        logger: logger,
        launcher: launcher,
      );

      final opened = await service.openPrivacyPolicy();

      expect(opened, isFalse);
      expect(launcher.launchCount, 1);
      expect(logger.warnings, isNotEmpty);
    });
  });
}

/// Purpose: Capture outgoing URL launches for privacy-policy unit tests.
class _FakeUrlLauncherGateway implements UrlLauncherGateway {
  Uri? lastUri;
  LaunchMode? lastMode;
  bool nextResult = true;
  int launchCount = 0;

  @override
  Future<bool> launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    launchCount += 1;
    lastUri = uri;
    lastMode = mode;
    return nextResult;
  }
}
