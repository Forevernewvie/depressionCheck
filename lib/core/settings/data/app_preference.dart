import 'package:isar/isar.dart';

part 'app_preference.g.dart';

@collection
class AppPreference {
  AppPreference({
    this.id = singletonId,
    this.themePreference = 'system',
    this.languagePreference = 'system',
    this.onboardingCompleted = false,
  });

  static const int singletonId = 0;

  Id id;
  String themePreference;
  String languagePreference;
  bool onboardingCompleted;
}
