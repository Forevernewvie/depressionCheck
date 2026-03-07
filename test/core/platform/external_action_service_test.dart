import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/platform/external_action_service.dart';
import 'package:vibemental_app/core/platform/url_launcher_gateway.dart';
import 'package:vibemental_app/core/result/app_result.dart';

import '../../fakes/test_app_logger.dart';

void main() {
  group('UrlLauncherExternalActionService', () {
    late _FakeUrlLauncherGateway launcher;
    late TestAppLogger logger;
    late UrlLauncherExternalActionService service;

    setUp(() {
      launcher = _FakeUrlLauncherGateway();
      logger = TestAppLogger();
      service = UrlLauncherExternalActionService(
        logger: logger,
        launcher: launcher,
      );
    });

    test('returns validation failure when phone is invalid', () async {
      final result = await service.callPhone('()');

      expect(result, isA<AppError<void>>());
      expect((result as AppError<void>).failure, isA<ValidationFailure>());
      expect(launcher.launchCount, 0);
    });

    test('sanitizes phone and launches dialer when input is valid', () async {
      final result = await service.callPhone('+1 (555) 123-4567');

      expect(result, isA<AppSuccess<void>>());
      expect(launcher.lastUri, isNotNull);
      expect(launcher.lastUri!.scheme, 'tel');
      expect(launcher.lastUri!.path, '+15551234567');
      expect(launcher.lastMode, LaunchMode.platformDefault);
    });

    test('returns validation failure when coordinates are invalid', () async {
      final result = await service.openDirections(
        latitude: 200,
        longitude: 127,
      );

      expect(result, isA<AppError<void>>());
      expect((result as AppError<void>).failure, isA<ValidationFailure>());
      expect(launcher.launchCount, 0);
    });

    test('launches secure directions URI with external mode', () async {
      final result = await service.openDirections(
        latitude: 37.566535,
        longitude: 126.9779692,
      );

      expect(result, isA<AppSuccess<void>>());
      expect(launcher.lastUri, isNotNull);
      expect(launcher.lastUri!.scheme, 'https');
      expect(launcher.lastUri!.host, 'www.google.com');
      expect(launcher.lastUri!.queryParameters['api'], '1');
      expect(
        launcher.lastUri!.queryParameters['query'],
        '37.566535,126.977969',
      );
      expect(launcher.lastMode, LaunchMode.externalApplication);
    });

    test('returns launch failure when launcher rejects directions', () async {
      launcher.nextResult = false;

      final result = await service.openDirections(
        latitude: 37.566535,
        longitude: 126.9779692,
      );

      expect(result, isA<AppError<void>>());
      expect((result as AppError<void>).failure.code, 'map_launch_failed');
      expect(logger.warnings, isNotEmpty);
    });
  });
}

/// Purpose: Capture URI launch attempts without touching platform channels in
/// unit tests.
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
