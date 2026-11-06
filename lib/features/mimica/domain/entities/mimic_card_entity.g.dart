// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mimic_card_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MimicCardEntityImpl _$$MimicCardEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$MimicCardEntityImpl(
      id: json['id'] as String,
      category: $enumDecode(_$GameCategoryEnumMap, json['category']),
      riskLevel: $enumDecode(_$RiskLevelEnumMap, json['riskLevel']),
      primaryWord: json['primaryWord'] as String,
      secondaryWord: json['secondaryWord'] as String?,
      physicalPenalty: json['physicalPenalty'] as String?,
    );

Map<String, dynamic> _$$MimicCardEntityImplToJson(
        _$MimicCardEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': _$GameCategoryEnumMap[instance.category]!,
      'riskLevel': _$RiskLevelEnumMap[instance.riskLevel]!,
      'primaryWord': instance.primaryWord,
      'secondaryWord': instance.secondaryWord,
      'physicalPenalty': instance.physicalPenalty,
    };

const _$GameCategoryEnumMap = {
  GameCategory.acoes: 'acoes',
  GameCategory.objetos: 'objetos',
  GameCategory.lugares: 'lugares',
  GameCategory.animais: 'animais',
  GameCategory.verbos: 'verbos',
  GameCategory.filmes: 'filmes',
  GameCategory.herois: 'herois',
  GameCategory.profissoes: 'profissoes',
  GameCategory.esportes: 'esportes',
  GameCategory.comidas: 'comidas',
  GameCategory.cep: 'cep',
  GameCategory.dificilAleatorio: 'dificil_aleatorio',
};

const _$RiskLevelEnumMap = {
  RiskLevel.easy: 'easy',
  RiskLevel.normal: 'normal',
  RiskLevel.hard: 'hard',
  RiskLevel.bonus: 'bonus',
};

