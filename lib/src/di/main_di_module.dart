import 'package:casino_test/src/data/providers/character_remote_provider.dart';
import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/providers/network_check_provider_impl.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/data/repository/characters_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../data/providers/character_remote_provider_impl.dart';

class MainDIModule {
  void configure(GetIt getIt) {
    final httpClient = Client();

    getIt.registerLazySingleton<CharacterRemoteProvider>(
      () => CharacterRemoteProviderImpl(httpClient),
    );

    getIt.registerLazySingleton<CharactersRepository>(
      () => CharactersRepositoryImpl(getIt()),
    );

    getIt.registerLazySingleton<NetworkCheckProvider>(
      () => NetworkCheckProviderImpl(InternetConnectionChecker()),
    );
  }
}
