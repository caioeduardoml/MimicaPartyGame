// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamEntityImpl _$$TeamEntityImplFromJson(Map<String, dynamic> json) =>
    _$TeamEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      playersCount: (json['playersCount'] as num?)?.toInt() ?? 2,
      score: (json['score'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TeamEntityImplToJson(_$TeamEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'playersCount': instance.playersCount,
      'score': instance.score,
    };

