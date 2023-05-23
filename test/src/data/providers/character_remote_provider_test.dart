import 'package:casino_test/src/data/models/paginated.dart';
import 'package:casino_test/src/data/providers/character_remote_provider.dart';
import 'package:casino_test/src/data/providers/character_remote_provider_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixture.dart';

class MockClient extends Mock implements Client {}

void main() {
  late CharacterRemoteProvider characterRemoteProvider;
  late MockClient httpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    httpClient = MockClient();
    characterRemoteProvider = CharacterRemoteProviderImpl(httpClient);
  });

  group('CharacterRemoteProvider', () {
    test('Should return a PaginatedCharacters', () async {
      // Arrange
      final responseString = readStringFixture('character_response.json');
      final responseCode = 200;
      final response = Response(responseString, responseCode);
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      // Act
      final result = await characterRemoteProvider.getCharacters(1);

      // Assert
      expect(result, isA<PaginatedCharacters>());
      expect(result.results.first.name, equals('Toxic Rick'));
      verify(() => httpClient.get(any())).called(1);
    });
  });
}
