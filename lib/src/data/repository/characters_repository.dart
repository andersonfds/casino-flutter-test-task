import '../models/paginated.dart';

abstract class CharactersRepository {
  Future<PaginatedCharacters> getCharactersOnline(int page);
}
