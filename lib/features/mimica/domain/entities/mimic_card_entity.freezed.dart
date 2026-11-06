// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mimic_card_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MimicCardEntity _$MimicCardEntityFromJson(Map<String, dynamic> json) {
  return _MimicCardEntity.fromJson(json);
}

/// @nodoc
mixin _$MimicCardEntity {
  String get id => throw _privateConstructorUsedError;
  GameCategory get category => throw _privateConstructorUsedError;
  RiskLevel get riskLevel => throw _privateConstructorUsedError;
  String get primaryWord => throw _privateConstructorUsedError;
  String? get secondaryWord => throw _privateConstructorUsedError;
  String? get physicalPenalty => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MimicCardEntityCopyWith<MimicCardEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MimicCardEntityCopyWith<$Res> {
  factory $MimicCardEntityCopyWith(
          MimicCardEntity value, $Res Function(MimicCardEntity) then) =
      _$MimicCardEntityCopyWithImpl<$Res, MimicCardEntity>;
  @useResult
  $Res call(
      {String id,
      GameCategory category,
      RiskLevel riskLevel,
      String primaryWord,
      String? secondaryWord,
      String? physicalPenalty});
}

/// @nodoc
class _$MimicCardEntityCopyWithImpl<$Res, $Val extends MimicCardEntity>
    implements $MimicCardEntityCopyWith<$Res> {
  _$MimicCardEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? riskLevel = null,
    Object? primaryWord = null,
    Object? secondaryWord = freezed,
    Object? physicalPenalty = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as GameCategory,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RiskLevel,
      primaryWord: null == primaryWord
          ? _value.primaryWord
          : primaryWord // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryWord: freezed == secondaryWord
          ? _value.secondaryWord
          : secondaryWord // ignore: cast_nullable_to_non_nullable
              as String?,
      physicalPenalty: freezed == physicalPenalty
          ? _value.physicalPenalty
          : physicalPenalty // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MimicCardEntityImplCopyWith<$Res>
    implements $MimicCardEntityCopyWith<$Res> {
  factory _$$MimicCardEntityImplCopyWith(_$MimicCardEntityImpl value,
          $Res Function(_$MimicCardEntityImpl) then) =
      __$$MimicCardEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      GameCategory category,
      RiskLevel riskLevel,
      String primaryWord,
      String? secondaryWord,
      String? physicalPenalty});
}

/// @nodoc
class __$$MimicCardEntityImplCopyWithImpl<$Res>
    extends _$MimicCardEntityCopyWithImpl<$Res, _$MimicCardEntityImpl>
    implements _$$MimicCardEntityImplCopyWith<$Res> {
  __$$MimicCardEntityImplCopyWithImpl(
      _$MimicCardEntityImpl _value, $Res Function(_$MimicCardEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? riskLevel = null,
    Object? primaryWord = null,
    Object? secondaryWord = freezed,
    Object? physicalPenalty = freezed,
  }) {
    return _then(_$MimicCardEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as GameCategory,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RiskLevel,
      primaryWord: null == primaryWord
          ? _value.primaryWord
          : primaryWord // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryWord: freezed == secondaryWord
          ? _value.secondaryWord
          : secondaryWord // ignore: cast_nullable_to_non_nullable
              as String?,
      physicalPenalty: freezed == physicalPenalty
          ? _value.physicalPenalty
          : physicalPenalty // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MimicCardEntityImpl extends _MimicCardEntity {
  const _$MimicCardEntityImpl(
      {required this.id,
      required this.category,
      required this.riskLevel,
      required this.primaryWord,
      this.secondaryWord,
      this.physicalPenalty})
      : super._();

  factory _$MimicCardEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$MimicCardEntityImplFromJson(json);

  @override
  final String id;
  @override
  final GameCategory category;
  @override
  final RiskLevel riskLevel;
  @override
  final String primaryWord;
  @override
  final String? secondaryWord;
  @override
  final String? physicalPenalty;

  @override
  String toString() {
    return 'MimicCardEntity(id: $id, category: $category, riskLevel: $riskLevel, primaryWord: $primaryWord, secondaryWord: $secondaryWord, physicalPenalty: $physicalPenalty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MimicCardEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.primaryWord, primaryWord) ||
                other.primaryWord == primaryWord) &&
            (identical(other.secondaryWord, secondaryWord) ||
                other.secondaryWord == secondaryWord) &&
            (identical(other.physicalPenalty, physicalPenalty) ||
                other.physicalPenalty == physicalPenalty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, category, riskLevel,
      primaryWord, secondaryWord, physicalPenalty);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MimicCardEntityImplCopyWith<_$MimicCardEntityImpl> get copyWith =>
      __$$MimicCardEntityImplCopyWithImpl<_$MimicCardEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MimicCardEntityImplToJson(
      this,
    );
  }
}

abstract class _MimicCardEntity extends MimicCardEntity {
  const factory _MimicCardEntity(
      {required final String id,
      required final GameCategory category,
      required final RiskLevel riskLevel,
      required final String primaryWord,
      final String? secondaryWord,
      final String? physicalPenalty}) = _$MimicCardEntityImpl;
  const _MimicCardEntity._() : super._();

  factory _MimicCardEntity.fromJson(Map<String, dynamic> json) =
      _$MimicCardEntityImpl.fromJson;

  @override
  String get id;
  @override
  GameCategory get category;
  @override
  RiskLevel get riskLevel;
  @override
  String get primaryWord;
  @override
  String? get secondaryWord;
  @override
  String? get physicalPenalty;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MimicCardEntityImplCopyWith<_$MimicCardEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

