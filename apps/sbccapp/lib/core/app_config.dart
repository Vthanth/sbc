import 'package:sbccapp/core/app_config_base.dart';

class AppConfig implements AppConfigBase {
  AppConfig(this._appFlavor);

  final AppFlavor _appFlavor;

  @override
  AppFlavor getAppFlavor() => _appFlavor;

  // STATIC HOSTS

  @override
  String get apiEndPoint => "https://erp.sbccindia.com/api/v1/";
}

enum ServerEnvironment { staging, production }

extension AppFlavorExtension on AppFlavor {
  ServerEnvironment get serverEnvironment {
    switch (this) {
      case AppFlavor.staging:
        return ServerEnvironment.staging;
      default:
        return ServerEnvironment.production;
    }
  }
}
