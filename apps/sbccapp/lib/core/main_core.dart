import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sbccapp/core/app_config_base.dart';
import 'package:sbccapp/core/router.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';
import 'package:sbccapp/helper/geolocator_helper.dart';
import 'package:sbccapp/services/location_tracking_manager.dart';
import 'package:sbccapp/stores/location.store.dart';
import 'package:sbccapp/stores/user.store.dart';
import 'package:sbccapp/utils/app_lifecycle_observer.dart';
import 'package:sbccapp/utils/mobx_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final providers = [
  MobxProvider(create: (context) => locator<UserStore>(), lazy: false),
  MobxProvider(create: (context) => locator<LocationStore>(), lazy: false),
];

class SbccApp extends StatefulWidget {
  // ignore: unused_field
  final AppConfigBase _config;

  @override
  // ignore: library_private_types_in_public_api
  _SbccAppState createState() => _SbccAppState();

  SbccApp(this._config, {super.key}) {
    // setupErrorWidget();
  }
}

class _SbccAppState extends State<SbccApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initialise();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
    );
    WidgetsBinding.instance.addObserver(locator<AppLifecycleObserver>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_loadDarkMode(context);
    });
  }

  void initialise() async {
    //Get current Position
    // If UUID not generated, generate and save it to shared preferences
    final sharedPref = await SharedPreferences.getInstance();
    final deviceUuid = sharedPref.getString(SHARED_PREFERENCE_KEY_DEVICE_UUID);
    if (deviceUuid == null) {
      final newUuid = Uuid().v4();
      await sharedPref.setString(SHARED_PREFERENCE_KEY_DEVICE_UUID, newUuid);
    }

    await GeolocatorHelper.getCurrentPosition(context);

    // Resume location tracking if user was checked in from previous session
    await locator<LocationTrackingManager>().resumeTrackingIfNeeded(context);

    //locator<PurchaseItemRepository>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp.router(
        theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.black;
                }
                return null;
              }),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: kRouter,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(locator<AppLifecycleObserver>());
    // Dispose location tracking manager
    locator<LocationTrackingManager>().dispose();
    super.dispose();
  }
}
