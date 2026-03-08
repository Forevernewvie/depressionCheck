/// Purpose: Define route path constants in one place to remove string
/// duplication and keep navigation refactors safe.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String phq2 = '/phq2';
  static const String phq9 = '/phq9';
  static const String result = '/result';
  static const String map = '/map';
  static const String settings = '/settings';
  static const String privacyPolicy = '/settings/privacy-policy';
  static const String modules = '/modules';
  static const String hadsD = '/modules/hads-d';
  static const String cesD = '/modules/ces-d';
  static const String bdi2 = '/modules/bdi-ii';
  static const String clinician = '/clinician';
  static const String checkIn = '/check-in';
  static const String safetyPlan = '/safety-plan';
}
