import 'package:get_it/get_it.dart';

import 'core/constants/database_constants.dart';
import 'repository/cache_repository.dart';
import 'repository/sms_repository.dart';
import 'services/local/app_database.dart';
import 'services/remote/sms/sms_service.dart';

/// `Dependecy Injection` using `get_it` package
final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  /// Database
  final database = await $FloorAppDatabase
      .databaseBuilder(
        kDatabaseName,
      )
      .build();
  injector.registerSingleton<AppDatabase>(database);

  /// Remote Services
  injector.registerSingleton<SMSService>(SMSService());

  /// Repositories
  injector.registerSingleton<SMSRepository>(SMSRepository(injector()));
  injector.registerSingleton<CacheRepository>(CacheRepository(injector()));
}
