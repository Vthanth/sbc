import 'package:app_network/app_network.dart';
import 'package:app_services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sbccapp/core/app_config_base.dart';
import 'package:sbccapp/repositories/attendance_repository_impl.dart';
import 'package:sbccapp/repositories/user_repository_impl.dart';
import 'package:sbccapp/services/device_metadata_service.dart';
import 'package:sbccapp/services/location_tracking_manager.dart';
import 'package:sbccapp/services/qr_code_service.dart';
import 'package:sbccapp/stores/attendance_page.store.dart';
import 'package:sbccapp/stores/completed_tickets_page.store.dart';
import 'package:sbccapp/stores/home_page.store.dart';
import 'package:sbccapp/stores/location.store.dart';
import 'package:sbccapp/stores/order_details.store.dart';
import 'package:sbccapp/stores/product_details.store.dart';
import 'package:sbccapp/stores/user.store.dart';
import 'package:sbccapp/utils/app_lifecycle_observer.dart';

final locator = GetIt.instance;

void setupLocator(AppConfigBase config) {
  locator.registerSingleton<AppConfigBase>(config);
  locator.registerLazySingleton<AppClient>(() => DefaultAppClient());
  locator.registerSingleton<AppFlavor>(config.getAppFlavor());
  locator.registerLazySingleton<AppLifecycleObserver>(() => AppLifecycleObserver());

  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(locator<UserNetworkService>(), locator<InstantLocalPersistenceService>()),
  );

  locator.registerLazySingleton<UserNetworkService>(
    () => UserNetworkServiceImpl(locator<AppClient>(), locator<AppConfigBase>()),
  );

  locator.registerLazySingleton<InstantLocalPersistenceService>(() {
    return DefaultLegacySharedPreference();
  });

  // Register services
  locator.registerLazySingleton<DeviceMetadataService>(() => DeviceMetadataService());
  locator.registerLazySingleton<LocationTrackingManager>(() => LocationTrackingManager());
  locator.registerLazySingleton<QRCodeService>(() => QRCodeService());

  // Register stores
  locator.registerLazySingleton<UserStore>(() => UserStore());
  locator.registerLazySingleton<LocationStore>(() => LocationStore());
  locator.registerLazySingleton<HomePageStore>(() => HomePageStore());
  locator.registerLazySingleton<AttendancePageStore>(() => AttendancePageStore());
  locator.registerLazySingleton<OrderDetailsStore>(() => OrderDetailsStore());
  locator.registerLazySingleton<ProductDetailsStore>(() => ProductDetailsStore());
  locator.registerLazySingleton<CompletedTicketsPageStore>(() => CompletedTicketsPageStore());

  locator.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(locator<AttendanceNetworkService>(), locator<InstantLocalPersistenceService>()),
  );

  locator.registerLazySingleton<AttendanceNetworkService>(
    () => AttendanceNetworkServiceImpl(locator<AppClient>(), locator<AppConfigBase>()),
  );

  // Initialize location tracking manager
  locator<LocationTrackingManager>().initialize();
}
