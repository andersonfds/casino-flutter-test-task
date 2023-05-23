import 'dart:convert';

import 'package:casino_test/src/data/models/paginated.dart';
import 'package:http/http.dart';

import 'character_remote_provider.dart';

const _kApiBaseUrl = "https://rickandmortyapi.com/api";

class CharacterRemoteProviderImpl implements CharacterRemoteProvider {
  final Client _http;

  CharacterRemoteProviderImpl(this._http);

  @override
  Future<PaginatedCharacters> getCharacters(int page) async {
    final characterListUrl = Uri.parse("$_kApiBaseUrl/character/").replace(
      queryParameters: {"page": "$page"},
    );

    final httpResult = await _http.get(characterListUrl);
    final jsonMap = await json.decode(httpResult.body) as Map<String, dynamic>;

    return PaginatedCharacters.fromJson(jsonMap);
  }
}
