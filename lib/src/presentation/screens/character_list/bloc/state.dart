import 'package:equatable/equatable.dart';

import '../../../../data/models/character.dart';

enum CharacterListPageStatus {
  initial,
  success,
  failure,
  loading,
  offline,
}

extension CharacterListPageStatusX on CharacterListPageStatus {
  bool get isSuccess => this == CharacterListPageStatus.success;
  bool get isFailure => this == CharacterListPageStatus.failure;
  bool get isLoading => this == CharacterListPageStatus.loading;
  bool get isOffline => this == CharacterListPageStatus.offline;
}

class CharacterListPageState extends Equatable {
  const CharacterListPageState({
    this.hasMore = true,
    this.characters = const [],
    this.status = CharacterListPageStatus.initial,
    this.page = 1,
  });

  final int page;
  final bool hasMore;
  final List<Character> characters;
  final CharacterListPageStatus status;

  CharacterListPageState copyWith({
    bool? hasMore,
    List<Character>? characters,
    CharacterListPageStatus? status,
    int? page,
  }) {
    return CharacterListPageState(
      hasMore: hasMore ?? this.hasMore,
      characters: characters ?? this.characters,
      status: status ?? this.status,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [hasMore, characters, status];
}

const initialCharacterListPageState = CharacterListPageState();
const emptyLoadingCharacterListPageState = CharacterListPageState(
  status: CharacterListPageStatus.loading,
);
const errorEmptyCharacterListPageState = CharacterListPageState(
  status: CharacterListPageStatus.failure,
);
