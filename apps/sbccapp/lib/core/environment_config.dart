import 'app_config_base.dart';

class EnvironmentConfig {
  // ignore: constant_identifier_names
  static const String Flavor = String.fromEnvironment("flavor");
  static AppFlavor get flavor {
    if (Flavor.trim().isEmpty) {
      return AppFlavor.black;
    }
    return AppFlavor.values.firstWhere(
      (element) => Flavor.trim().toLowerCase() == element.name.toLowerCase(),
      orElse: () => AppFlavor.black,
    );
  }

  static const bool enableDevicePreview = bool.fromEnvironment("enableDevicePreview");
  static const bool enableCurlCommandLog = bool.fromEnvironment("enableCurlCommandLog");
}
