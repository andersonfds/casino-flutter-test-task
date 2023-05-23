import 'package:bloc_test/bloc_test.dart';
import 'package:casino_test/src/data/models/paginated.dart';
import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/screens/character_list/bloc/bloc.dart';
import 'package:casino_test/src/presentation/screens/character_list/bloc/event.dart';
import 'package:casino_test/src/presentation/screens/character_list/bloc/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/fixture.dart';

class MockCharactersRepository extends Mock implements CharactersRepository {}

class MockNetworkCheckProvider extends Mock implements NetworkCheckProvider {}

void main() {
  late MockCharactersRepository repository;
  late MockNetworkCheckProvider networkChecker;
  late PaginatedCharacters mockResponseWithMoreResults;

  setUpAll(() {
    mockResponseWithMoreResults = PaginatedCharacters.fromJson(
      readJsonFixture('character_response.json'),
    );
  });

  setUp(() {
    repository = MockCharactersRepository();
    networkChecker = MockNetworkCheckProvider();
  });

  group('MainBloc', () {
    group('Given user has internet', () {
      group('When successfull api request', () {
        setUp(() {
          when(() => repository.getCharactersOnline(any())).thenAnswer(
            (_) async => mockResponseWithMoreResults,
          );
          when(() => networkChecker.networkState).thenAnswer(
            (_) => Stream.value(true),
          );
        });

        blocTest<CharacterListBloc, CharacterListPageState>(
          'Then should fetch a page',
          build: () => CharacterListBloc(
            initialCharacterListPageState,
            repository,
            networkChecker,
          ),
          act: (bloc) => bloc.add(CharacterListFetchEvent.initial()),
          verify: (bloc) {
            final blocState = bloc.state.copyWith();
            verify(() => repository.getCharactersOnline(any())).called(1);
            expect(
              bloc.state.characters,
              equals(mockResponseWithMoreResults.results),
            );
            expect(blocState.status, equals(CharacterListPageStatus.success));
          },
        );

        blocTest<CharacterListBloc, CharacterListPageState>(
          'When there is data should append the new result',
          build: () => CharacterListBloc(
            CharacterListPageState(
              characters: mockResponseWithMoreResults.results,
              page: 1,
              status: CharacterListPageStatus.success,
              hasMore: true,
            ),
            repository,
            networkChecker,
          ),
          act: (bloc) => bloc.add(OnEdgeHitEvent()),
          verify: (bloc) {
            expect(bloc.state.characters.length, equals(2));
            expect(bloc.state.page, equals(2));
          },
        );

        blocTest<CharacterListBloc, CharacterListPageState>(
          'When restablished internet connection should make another attempt',
          build: () => CharacterListBloc(
              errorEmptyCharacterListPageState, repository, networkChecker),
          act: (bloc) => bloc.add(CharacterNetworkEvent.initial()),
          verify: (bloc) {
            verify(() => repository.getCharactersOnline(1)).called(1);
            verify(() => networkChecker.networkState).called(1);
            expect(bloc.state.status, equals(CharacterListPageStatus.success));
          },
        );

        blocTest<CharacterListBloc, CharacterListPageState>(
          'When offline then emit the offline status',
          build: () => CharacterListBloc(
            emptyLoadingCharacterListPageState,
            repository,
            networkChecker,
          ),
          setUp: () {
            when(() => networkChecker.networkState)
                .thenAnswer((_) => Stream.value(false));
          },
          act: (bloc) => bloc.add(CharacterNetworkEvent.initial()),
          verify: (bloc) {
            verify(() => networkChecker.networkState).called(1);
            expect(bloc.state.status, equals(CharacterListPageStatus.offline));
          },
        );
      });
    });

    group('Given user has no internet', () {
      setUp(() {
        when(() => repository.getCharactersOnline(any())).thenAnswer(
          (_) => Future.error('No data'),
        );
      });

      blocTest<CharacterListBloc, CharacterListPageState>(
        'Then should emit failure state',
        build: () => CharacterListBloc(
          emptyLoadingCharacterListPageState,
          repository,
          networkChecker,
        ),
        act: (bloc) => bloc.add(CharacterListFetchEvent.initial()),
        verify: (bloc) {
          verify(() => repository.getCharactersOnline(any())).called(1);
          expect(bloc.state.status, equals(CharacterListPageStatus.failure));
        },
      );
    });
  });
}
