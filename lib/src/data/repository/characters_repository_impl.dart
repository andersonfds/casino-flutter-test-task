import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/providers/character_remote_provider.dart';
import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharacterRemoteProvider _characterProvider;
  final NetworkCheckProvider _networkCheckProvider;

  CharactersRepositoryImpl(
    this._characterProvider,
    this._networkCheckProvider,
  );

  @override
  Future<List<Character>?> getCharactersOnline(int page) async {
    if (!await _networkCheckProvider.isOnline()) {
      return Future.value(null);
    }

    return _characterProvider.getCharacters(page);
  }
}
