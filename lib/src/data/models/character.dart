import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable(createToJson: false)
class Character {
  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String image;

  @JsonKey(defaultValue: '')
  final String gender;

  @JsonKey(defaultValue: '')
  final String status;

  const Character(this.name, this.image, this.gender, this.status);

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}
