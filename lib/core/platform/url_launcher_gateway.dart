import 'package:url_launcher/url_launcher.dart';

/// Purpose: Abstract URL launching so platform integrations stay mockable in
/// unit tests and replaceable per platform.
abstract class UrlLauncherGateway {
  /// Purpose: Launch a URI using the requested platform mode.
  Future<bool> launch(Uri uri, {LaunchMode mode = LaunchMode.platformDefault});
}

/// Purpose: Delegate URL launching to the `url_launcher` plugin in production.
class SystemUrlLauncherGateway implements UrlLauncherGateway {
  const SystemUrlLauncherGateway();

  @override
  Future<bool> launch(Uri uri, {LaunchMode mode = LaunchMode.platformDefault}) {
    return launchUrl(uri, mode: mode);
  }
}
