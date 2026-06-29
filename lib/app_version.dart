/// Keep in sync with `version:` in pubspec.yaml (name+build).
class AppVersion {
  AppVersion._();

  static const String name = '1.0.0';
  static const int buildNumber = 3;

  static String get label => 'v$name ($buildNumber)';

  static const String developerPhone = '0962520885';
  static const String developerCredit = '2ms developers';
}
