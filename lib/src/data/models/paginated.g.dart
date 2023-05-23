// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedCharacters _$PaginatedCharactersFromJson(Map<String, dynamic> json) =>
    PaginatedCharacters(
      (json['results'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
      PaginationInfo.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedCharactersToJson(
        PaginatedCharacters instance) =>
    <String, dynamic>{
      'results': instance.results,
      'info': instance.info,
    };

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) =>
    PaginationInfo(
      json['count'] as int,
      json['pages'] as int,
      json['next'] as String?,
    );

Map<String, dynamic> _$PaginationInfoToJson(PaginationInfo instance) =>
    <String, dynamic>{
      'count': instance.count,
      'pages': instance.pages,
      'next': instance.next,
    };
