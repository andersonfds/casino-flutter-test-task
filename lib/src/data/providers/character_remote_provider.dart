import '../models/paginated.dart';

abstract class CharacterRemoteProvider {
  Future<PaginatedCharacters> getCharacters(int page);
}
