import 'package:casino_test/src/data/providers/character_remote_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';

import '../models/paginated.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharacterRemoteProvider _characterProvider;

  CharactersRepositoryImpl(
    this._characterProvider,
  );

  @override
  Future<PaginatedCharacters> getCharactersOnline(int page) async {
    return _characterProvider.getCharacters(page);
  }
}
