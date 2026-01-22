import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/recipe_repository.dart';
import '../../data/services/recipe_api_service.dart';
import '../../data/services/local_storage_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // HTTP Client
  getIt.registerSingleton<http.Client>(http.Client());

  // Services
  getIt.registerSingleton<RecipeApiService>(
    RecipeApiService(getIt<http.Client>()),
  );

  getIt.registerSingleton<LocalStorageService>(
    LocalStorageService(getIt<SharedPreferences>()),
  );

  // Repository
  getIt.registerSingleton<RecipeRepository>(
    RecipeRepository(
      apiService: getIt<RecipeApiService>(),
      storageService: getIt<LocalStorageService>(),
    ),
  );
}
