import 'package:casino_test/src/data/models/character.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated.g.dart';

@JsonSerializable()
class PaginatedCharacters {
  PaginatedCharacters(this.results, this.info);

  factory PaginatedCharacters.fromJson(Map<String, dynamic> json) =>
      _$PaginatedCharactersFromJson(json);

  final List<Character> results;
  final PaginationInfo info;

  Map<String, dynamic> toJson() => _$PaginatedCharactersToJson(this);
}

@JsonSerializable()
class PaginationInfo {
  PaginationInfo(this.count, this.pages, this.next);

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);

  final int count;
  final int pages;
  final String? next;
  bool get hasNextPage => next?.isNotEmpty ?? false;

  Map<String, dynamic> toJson() => _$PaginationInfoToJson(this);
}
