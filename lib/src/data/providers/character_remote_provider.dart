import 'package:casino_test/src/data/models/character.dart';

abstract class CharacterRemoteProvider {
  Future<List<Character>?> getCharacters(int page);
}

