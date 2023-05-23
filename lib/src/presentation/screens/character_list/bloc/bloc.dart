import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

typedef EmitterState = Emitter<CharacterListPageState>;

class CharacterListBloc
    extends Bloc<CharacterListEvent, CharacterListPageState> {
  CharacterListBloc(
    CharacterListPageState initialState,
    this._repository,
    this._networkCheck,
  ) : super(initialState) {
    on<CharacterListFetchEvent>(_fetchCharacters, transformer: sequential());
    on<CharacterNetworkEvent>(_watchNetwork, transformer: sequential());
    on<OnEdgeHitEvent>(_onEdgeHit, transformer: droppable());
  }

  final CharactersRepository _repository;
  final NetworkCheckProvider _networkCheck;

  Future<void> _fetchCharacters(
    CharacterListFetchEvent event,
    EmitterState emit,
  ) async {
    // Emitting loading state
    emit(state.copyWith(status: CharacterListPageStatus.loading));

    return _repository.getCharactersOnline(event.page).then((response) {
      final mergedCharacters = [...state.characters, ...response.results];

      return emit(state.copyWith(
        page: event.page,
        characters: mergedCharacters,
        hasMore: response.info.next != null,
        status: CharacterListPageStatus.success,
      ));
    }).catchError((error) {
      return emit(state.copyWith(
        status: CharacterListPageStatus.failure,
      ));
    });
  }

  Future<void> _onEdgeHit(
    OnEdgeHitEvent event,
    EmitterState emit,
  ) async {
    final nextPageNumber = state.page + 1;
    return _fetchCharacters(CharacterListFetchEvent.next(nextPageNumber), emit);
  }

  Future<void> _watchNetwork(
    CharacterNetworkEvent event,
    EmitterState emit,
  ) async {
    return emit.forEach<bool>(
      _networkCheck.networkState,
      onData: (hasInternet) {
        if (hasInternet) {
          // Retrying from offline failure
          if (state.status == CharacterListPageStatus.failure) {
            add(CharacterListFetchEvent(state.page));
          }

          // Returning to success
          return state.copyWith(
            status: CharacterListPageStatus.success,
          );
        }

        // Going offline
        return state.copyWith(
          status: CharacterListPageStatus.offline,
        );
      },
    );
  }
}
