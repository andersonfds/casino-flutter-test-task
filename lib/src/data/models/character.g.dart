// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      json['name'] as String? ?? '',
      json['image'] as String? ?? '',
      json['gender'] as String? ?? '',
      json['status'] as String? ?? '',
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'gender': instance.gender,
      'status': instance.status,
    };
