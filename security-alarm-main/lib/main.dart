import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/providers/scenario_provider.dart';
import 'package:security_alarm/providers/scheduling_provider.dart';
import 'package:security_alarm/providers/smart_control_provider.dart';
import 'package:security_alarm/repository/scheduling_repository.dart';
import 'package:security_alarm/providers/sms_provider.dart';

import 'config/routes/app_routes.dart';
import 'config/themes/app_themes.dart';
import 'core/constants/design_values.dart';
import 'core/constants/global_keys.dart';
import 'injector.dart';
import 'providers/add_device_provider.dart';
import 'providers/advance_tools_provider.dart';
import 'providers/app_settings_provider.dart';
import 'providers/audio_notification_provider.dart';
import 'providers/charge_device_provider.dart';
import 'providers/contacts_provider.dart';
import 'providers/device_settings_provider.dart';
import 'providers/home_provider.dart';
import 'providers/main_provider.dart';
import 'providers/setup_provider.dart';
import 'providers/splash_provider.dart';
import 'providers/zones_provider.dart';
import 'repository/cache_repository.dart';

late LocalizationDelegate delegate;
ThemeData themeData = AppThemes.palette1;

// Add a handler for GlobalKey errors in debug mode
void _setupGlobalKeyErrorHandler() {
  if (kDebugMode) {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is StateError &&
          details.exception.toString().contains('GlobalKey')) {
        debugPrint('GlobalKey Error: ${details.exception}');
        // Continue execution despite the error
        return;
      }
      FlutterError.presentError(details);
    };
  }
}

Future<void> main() async {
  // Make sure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup error handler for GlobalKey issues
  _setupGlobalKeyErrorHandler();
  
  // Original main content
  await startupSetup();
  await getThemeFromDatabase();
  // await initializeDependencies();
  delegate = await LocalizationDelegate.create(
    fallbackLocale: 'fa',
    supportedLocales: ['fa', 'en'],
  );
  await delegate.changeLocale(Locale('fa'));
  runApp(LocalizedApp(delegate, MultiProvider(
    providers: [
      ChangeNotifierProvider<MainProvider>(
        create: (_) => MainProvider(),
      ),
      ChangeNotifierProxyProvider<MainProvider, AddDeviceProvider>(
        create: (_) => AddDeviceProvider(null),
        update: (context, main, addDevice) => AddDeviceProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, AdvanceToolsProvider>(
        create: (_) => AdvanceToolsProvider(null),
        update: (context, main, advanceTools) => AdvanceToolsProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, AppSettingsProvider>(
        create: (_) => AppSettingsProvider(null),
        update: (context, main, appSettings) => AppSettingsProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, AudioNotificationProvider>(
        create: (_) => AudioNotificationProvider(null),
        update: (context, main, notification) => AudioNotificationProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, ChargeDeviceProvider>(
        create: (_) => ChargeDeviceProvider(null),
        update: (context, main, chargeDevice) => ChargeDeviceProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, ContactsProvider>(
        create: (_) => ContactsProvider(null),
        update: (context, main, contacts) => ContactsProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, ScenarioProvider>(
        create: (_) => ScenarioProvider(null),
        update: (context, main, remotes) => ScenarioProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, DeviceSettingsProvider>(
        create: (_) => DeviceSettingsProvider(null),
        update: (context, main, deviceSettings) =>
            DeviceSettingsProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, SplashProvider>(
        create: (_) => SplashProvider(null),
        update: (context, main, splash) => SplashProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, ZonesProvider>(
        create: (_) => ZonesProvider(null),
        update: (context, main, zones) => ZonesProvider(main),
      ),
      ChangeNotifierProxyProvider2<MainProvider, ChargeDeviceProvider,
          HomeProvider>(
        create: (_) => HomeProvider(null, null),
        update: (context, main, chargeDevice, home) => HomeProvider(
          main,
          chargeDevice,
        ),
      ),
      ChangeNotifierProxyProvider<MainProvider, SetupProvider>(
        create: (_) => SetupProvider(null),
        update: (context, main, setup) => SetupProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, SmartControlProvider>(
        create: (_) => SmartControlProvider(null),
        update: (context, main, smartControl) => SmartControlProvider(main),
      ),
      ChangeNotifierProxyProvider<MainProvider, SmsProvider>(
        create: (_) => SmsProvider(null),
        update: (context, main, smsProvider) => SmsProvider(main),
      ),
      Provider<SchedulingRepository>(
        create: (_) => SchedulingRepository(injector()),
      ),
    ],
    child: MyApp(themeData: themeData),
  )));
}

Future startupSetup() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Configure dependency injections
  await initializeDependencies();

  /// configure localization
  delegate = await LocalizationDelegate.create(
    fallbackLocale: 'fa',
    supportedLocales: ['fa'],
  );

  /// If the OS is `not web`
  if (!kIsWeb) {
    /// Open app only in `portrait` mode
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    /// Sets device `status bar` and `navigation bar` color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
}

Future getThemeFromDatabase() async {
  await injector<CacheRepository>().getAppSettings().then(
        (value) {
      if (value != null) {
        if (value.selectedThemePalette == 0) {
          themeData = AppThemes.palette1;
        } else if (value.selectedThemePalette == 1) {
          themeData = AppThemes.palette2;
        } else if (value.selectedThemePalette == 2) {
          themeData = AppThemes.palette3;
        }
      }
    },
  );
}

class MyApp extends StatelessWidget {
  final ThemeData themeData;
  const MyApp({
    Key? key,
    required this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    
    // Connect MainProvider and ZonesProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mainProvider = Provider.of<MainProvider>(context, listen: false);
      final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
      mainProvider.setZonesProvider(zonesProvider);
    });

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: ScreenUtilInit(
        designSize: kDesignSizeMobile,
        minTextAdapt: false,
        builder: (_, __) => MaterialApp(
          navigatorKey: kNavigatorKey,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          title: translate('app_title'),
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate,
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          debugShowCheckedModeBanner: false,
          theme: themeData,
          onGenerateRoute: AppRoutes.onGenerateRoutes,
          onGenerateInitialRoutes: AppRoutes.onGenerateInitialRoute,
        ),
      ),
    );
  }
}
