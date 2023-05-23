import 'package:casino_test/src/data/models/paginated.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixture.dart';

void main() {
  group('PaginatedCharacters', () {
    test('hasNextPage is true when next variable is set', () {
      // Arrange
      final characterJson = readJsonFixture('character_response.json');
      final character = PaginatedCharacters.fromJson(characterJson);

      // Act
      final hasNextPage = character.info.hasNextPage;

      // Assert
      expect(hasNextPage, isTrue);
    });
  });
}
