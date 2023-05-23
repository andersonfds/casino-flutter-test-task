import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/presentation/bloc/enum/main_status.dart';
import 'package:equatable/equatable.dart';

class MainPageState extends Equatable {
  MainPageState(
    this.characters,
    this.page,
    this.status, {
    required this.hasNextPage,
  });

  final List<Character> characters;
  final int page;
  final bool hasNextPage;
  final MainStatus status;

  MainPageState copyWith({
    List<Character>? characters,
    int? page,
    MainStatus? status,
    bool? hasNextPage,
  }) {
    return MainPageState(
      characters ?? this.characters,
      page ?? this.page,
      status ?? this.status,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  int next() {
    if (!hasNextPage) {
      throw Exception('No more pages');
    }

    return page + 1;
  }

  @override
  List<Object?> get props => [characters, page, status];
}

class InitialLoadingPageState extends MainPageState {
  InitialLoadingPageState()
      : super(
          [],
          0,
          MainStatus.loading,
          hasNextPage: true,
        );
}

class SuccessPageState extends MainPageState {
  SuccessPageState(
    List<Character> characters,
    int page, {
    required bool hasNextPage,
  }) : super(
          characters,
          page,
          MainStatus.success,
          hasNextPage: hasNextPage,
        );
}
