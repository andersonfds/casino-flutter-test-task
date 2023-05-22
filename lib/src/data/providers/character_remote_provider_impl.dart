import 'dart:convert';

import 'package:casino_test/src/data/models/character.dart';
import 'package:http/http.dart';

import 'character_remote_provider.dart';

const _kApiBaseUrl = "https://rickandmortyapi.com/api";

class CharacterRemoteProviderImpl implements CharacterRemoteProvider {
  final Client _http;

  CharacterRemoteProviderImpl(this._http);

  @override
  Future<List<Character>?> getCharacters(int page) async {
    final characterListUrl = Uri.parse("$_kApiBaseUrl/character/").replace(
      queryParameters: {"page": "$page"},
    );

    final httpResult = await _http.get(characterListUrl);
    final jsonMap = await json.decode(httpResult.body) as Map<String, dynamic>;
    final results = jsonMap["results"] as List<dynamic>;

    return List.of(
      results.map(
        (value) => Character.fromJson(value as Map<String, dynamic>),
      ),
    );
  }
}
