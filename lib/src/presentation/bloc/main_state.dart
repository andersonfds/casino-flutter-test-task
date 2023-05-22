import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/presentation/bloc/enum/main_status.dart';
import 'package:equatable/equatable.dart';

class MainPageState extends Equatable {
  MainPageState(this.characters, this.page, this.status);

  final List<Character> characters;
  final int page;
  final MainStatus status;

  MainPageState copyWith({
    List<Character>? characters,
    int? page,
    MainStatus? status,
  }) {
    return MainPageState(
      characters ?? this.characters,
      page ?? this.page,
      status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [characters, page, status];
}

class InitialLoadingPageState extends MainPageState {
  InitialLoadingPageState() : super([], 0, MainStatus.loading);
}

class SuccessPageState extends MainPageState {
  SuccessPageState(List<Character> characters, int page)
      : super(characters, page, MainStatus.success);
}
