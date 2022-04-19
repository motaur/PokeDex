import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart';
import 'package:poke/providers/pokemon_provider.dart';
import 'package:poke/repository/pokemon_api_repository.dart';
import 'package:poke/services/pokemon_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

initDi() async {
  getIt.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());
  getIt.registerSingleton<Logger>(Logger());

  getIt.registerFactory<PokemonApiRepository>(() =>
      PokemonApiRepository(getIt.get<Logger>())
      // PokemonMockRepository()
  );

  getIt.registerFactory<PokemonService>(() => PokemonService(getIt.get<PokemonApiRepository>(), getIt.get<SharedPreferences>()));
  getIt.registerFactory<PokemonProvider>(() => PokemonProvider(getIt.get<PokemonService>()));
}