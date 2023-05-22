import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/bloc/main_event.dart';
import 'package:casino_test/src/presentation/bloc/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'enum/main_status.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  final CharactersRepository _charactersRepo;
  final NetworkCheckProvider _networkCheck;

  MainPageBloc(
    MainPageState initialState,
    this._charactersRepo,
    this._networkCheck,
  ) : super(initialState) {
    on<MainPageFetch>(_fetchCharactersFromApi, transformer: sequential());
    on<NetworkChanged>(_watchNetworkChanges, transformer: sequential());
  }

  Future<void> _watchNetworkChanges(
    NetworkChanged event,
    Emitter<MainPageState> emit,
  ) {
    return emit.forEach<bool>(
      _networkCheck.networkState,
      onData: (hasInternet) {
        if (hasInternet) {
          if (state.status == MainStatus.failure) {
            add(MainPageFetch(state.page));
          }
        }
        final status = hasInternet ? MainStatus.success : MainStatus.offline;
        return state.copyWith(status: status);
      },
    );
  }

  Future<void> _fetchCharactersFromApi(
    MainPageFetch event,
    Emitter<MainPageState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MainStatus.loading));
      final currentData = state.characters;
      final result = await _charactersRepo.getCharactersOnline(event.page);

      if (result == null) {
        throw Exception('No data');
      }

      emit(SuccessPageState(currentData + result, event.page));
    } catch (_) {
      emit(state.copyWith(status: MainStatus.failure));
    }
  }
}
