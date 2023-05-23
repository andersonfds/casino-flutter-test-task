import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable(createToJson: false)
class Character {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String image;

  @JsonKey(defaultValue: '')
  final String gender;

  @JsonKey(defaultValue: '')
  final String status;

  @JsonKey(defaultValue: '')
  final String species;

  const Character(
    this.name,
    this.image,
    this.gender,
    this.status,
    this.species,
    this.id,
  );

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}
