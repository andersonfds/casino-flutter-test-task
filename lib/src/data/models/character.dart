import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {
  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String image;

  const Character(this.name, this.image);

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
