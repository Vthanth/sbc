import 'package:app_network/app_network.dart';

abstract class AppConfigBase implements NetworkConfigBase {
  AppFlavor getAppFlavor();

  // OTHERS
  static String communityGuidelinesUrl({String languageCode = "en"}) => '';
  //HelpDeskLinks.communityGuidelines(languageCode: languageCode);

  @override
  String get apiEndPoint => 'https://api.sbcc.com';
}

enum AppFlavor {
  white, // Android Play store release (White)
  red, // Android internal release (Maroon)
  black, // Android flutter release (Black)
  blue, // Android flutter Personalisation (Blue)
  yellow, // Android marketplace release (Yellow)
  green, // Android circles/groups release
  rainbow, // Rainbow
  butterfly, // Butterfly
  preprod, // Pre-prod firebase
  staging, // Production database with staging server
}

extension AppConfigBaseExtension on AppConfigBase {
  bool get isInternalBuild => isInternalAppBuild(getAppFlavor());

  bool get showStacktrace => isInternalAppBuild(getAppFlavor());
}

bool isInternalAppBuild(AppFlavor flavor) => flavor != AppFlavor.white;
