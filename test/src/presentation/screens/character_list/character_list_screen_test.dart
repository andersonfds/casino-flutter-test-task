import 'dart:io';

import 'package:casino_test/my_app.dart';
import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/models/paginated.dart';
import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/screens/character_details/character_details_screen.dart';
import 'package:casino_test/src/presentation/widgets/character_card.dart';
import 'package:casino_test/src/presentation/widgets/loading_center_widget.dart';
import 'package:casino_test/src/presentation/widgets/no_internet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixture.dart';

class MockCharactersRepository extends Mock implements CharactersRepository {}

class MockNetworkCheckProvider extends Mock implements NetworkCheckProvider {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockCharactersRepository repository;
  late MockNetworkCheckProvider networkCheck;

  setUp(() async {
    repository = MockCharactersRepository();
    networkCheck = MockNetworkCheckProvider();

    GetIt.I.registerFactory<CharactersRepository>(() => repository);
    GetIt.I.registerFactory<NetworkCheckProvider>(() => networkCheck);

    GetIt.I.allowReassignment = true;
  });

  group('CharacterListScreen', () {
    group('When failed to fetch', () {
      setUp(() {
        when(() => repository.getCharactersOnline(any()))
            .thenAnswer((_) => Future.error('error'));
        when(() => networkCheck.networkState)
            .thenAnswer((_) => Stream.value(true));
        HttpOverrides.global = null;
      });

      testWidgets('Should render error widget when is empty', (tester) async {
        // Act
        await tester.pumpWidget(MyApp());
        await tester.pumpAndSettle();
        await tester.tap(find.text('Try again'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(NoInternetWidget), findsOneWidget);
      });

      testWidgets('Should show loading', (tester) async {
        await tester.runAsync(() async {
          // Arrange
          when(() => repository.getCharactersOnline(any())).thenAnswer(
            (_) => Future.delayed(
              const Duration(seconds: 2),
              () => throw Exception('error'),
            ),
          );

          // Act
          await tester.pumpWidget(MyApp());
          await tester.pump(const Duration(seconds: 1));
          expect(find.byType(LoadingDataView), findsOneWidget);
          await tester.pumpAndSettle();

          // Assert
          expect(find.byType(LoadingDataView), findsNothing);
          verify(() => repository.getCharactersOnline(any())).called(1);
        });
      });

      testWidgets('Shows alert when user gets offline', (tester) async {
        // Arrange
        when(() => networkCheck.networkState)
            .thenAnswer((_) => Stream.fromIterable([true, false]));
        when(() => repository.getCharactersOnline(any()))
            .thenAnswer((_) => Future.error('error'));

        // Act
        await tester.pumpWidget(MyApp());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No internet connection'), findsOneWidget);
      });

      testWidgets('Should load again because hit the end', (tester) async {
        // Arrange
        when(() => repository.getCharactersOnline(any()))
            .thenAnswer((_) => Future.value(_generateMultipleCharacters()));

        // Act
        await tester.pumpWidget(MyApp());
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byType(CharacterCard).last);
        // drag the screen to the bottom
        await tester.drag(find.byType(Scrollable), const Offset(0, -900));

        await tester.pumpAndSettle();
        await tester.tap(find.byType(CharacterCard).first);
        await tester.pumpAndSettle();

        // Assert
        verify(() => repository.getCharactersOnline(1)).called(1);
        verify(() => repository.getCharactersOnline(2)).called(1);
        expect(find.byType(CharacterDetailsScreen), findsAtLeastNWidgets(1));
      });
    });
  });
}

PaginatedCharacters _generateMultipleCharacters() {
  final fixture = readJsonFixture('character_response.json');
  final results = fixture['results'] as List<dynamic>;

  final charactersMap = List.generate(
      10, (index) => <String, dynamic>{...results.first, 'id': index});

  final character = PaginatedCharacters.fromJson(fixture);
  final characters = charactersMap
      .cast<Map<dynamic, dynamic>>()
      .map(
        (characterMap) =>
            Character.fromJson(characterMap as Map<String, dynamic>),
      )
      .toList();
  return PaginatedCharacters(characters, character.info);
}
