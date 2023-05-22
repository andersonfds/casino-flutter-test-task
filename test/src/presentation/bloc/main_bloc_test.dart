import 'package:bloc_test/bloc_test.dart';
import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/bloc/enum/main_status.dart';
import 'package:casino_test/src/presentation/bloc/main_bloc.dart';
import 'package:casino_test/src/presentation/bloc/main_event.dart';
import 'package:casino_test/src/presentation/bloc/main_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

const mockCharacter = Character('name', 'image');

class MockCharactersRepository extends Mock implements CharactersRepository {}

class MockNetworkCheckProvider extends Mock implements NetworkCheckProvider {}

void main() {
  late MockCharactersRepository repository;
  late MockNetworkCheckProvider networkChecker;

  setUp(() {
    repository = MockCharactersRepository();
    networkChecker = MockNetworkCheckProvider();
  });

  group('MainBloc', () {
    group('Given user has internet', () {
      group('When successfull api request', () {
        setUp(() {
          when(() => repository.getCharactersOnline(any()))
              .thenAnswer((_) async => [mockCharacter]);
          when(() => networkChecker.networkState)
              .thenAnswer((_) => Stream.value(true));
        });

        blocTest<MainPageBloc, MainPageState>(
          'Then should fetch a page',
          build: () => MainPageBloc(
            InitialLoadingPageState(),
            repository,
            networkChecker,
          ),
          act: (bloc) => bloc.add(MainPageFetch(1)),
          verify: (bloc) {
            final blocState = bloc.state.copyWith();
            verify(() => repository.getCharactersOnline(any())).called(1);
            expect(bloc.state.characters, equals([mockCharacter]));
            expect(blocState.status, equals(MainStatus.success));
          },
        );

        blocTest<MainPageBloc, MainPageState>(
          'When there is data should append the new result',
          build: () => MainPageBloc(
            MainPageState([mockCharacter], 1, MainStatus.success),
            repository,
            networkChecker,
          ),
          act: (bloc) => bloc.add(MainPageFetch(2)),
          verify: (bloc) {
            expect(bloc.state.characters.length, equals(2));
            expect(bloc.state.page, equals(2));
          },
        );

        blocTest<MainPageBloc, MainPageState>(
          'When restablished internet connection should make another attempt',
          build: () => MainPageBloc(MainPageState([], 0, MainStatus.failure),
              repository, networkChecker),
          act: (bloc) => bloc.add(NetworkChanged()),
          verify: (bloc) {
            verify(() => repository.getCharactersOnline(0)).called(1);
            verify(() => networkChecker.networkState).called(1);
            expect(bloc.state.status, equals(MainStatus.success));
          },
        );

        blocTest<MainPageBloc, MainPageState>(
          'When offline then emit the offline status',
          build: () => MainPageBloc(
              InitialLoadingPageState(), repository, networkChecker),
          setUp: () {
            when(() => networkChecker.networkState)
                .thenAnswer((_) => Stream.value(false));
          },
          act: (bloc) => bloc.add(NetworkChanged()),
          verify: (bloc) {
            verify(() => networkChecker.networkState).called(1);
            expect(bloc.state.status, equals(MainStatus.offline));
          },
        );
      });
    });

    group('Given user has no internet', () {
      setUp(() {
        when(() => repository.getCharactersOnline(any()))
            .thenAnswer((_) async => null);
      });

      blocTest<MainPageBloc, MainPageState>(
        'Then should emit failure state',
        build: () => MainPageBloc(
          InitialLoadingPageState(),
          repository,
          networkChecker,
        ),
        act: (bloc) => bloc.add(MainPageFetch(1)),
        verify: (bloc) {
          verify(() => repository.getCharactersOnline(any())).called(1);
          expect(bloc.state.status, equals(MainStatus.failure));
        },
      );
    });
  });
}
