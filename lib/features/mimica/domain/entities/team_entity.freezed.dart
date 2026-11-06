// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeamEntity _$TeamEntityFromJson(Map<String, dynamic> json) {
  return _TeamEntity.fromJson(json);
}

/// @nodoc
mixin _$TeamEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get playersCount => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamEntityCopyWith<TeamEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamEntityCopyWith<$Res> {
  factory $TeamEntityCopyWith(
          TeamEntity value, $Res Function(TeamEntity) then) =
      _$TeamEntityCopyWithImpl<$Res, TeamEntity>;
  @useResult
  $Res call({String id, String name, int playersCount, int score});
}

/// @nodoc
class _$TeamEntityCopyWithImpl<$Res, $Val extends TeamEntity>
    implements $TeamEntityCopyWith<$Res> {
  _$TeamEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? playersCount = null,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      playersCount: null == playersCount
          ? _value.playersCount
          : playersCount // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamEntityImplCopyWith<$Res>
    implements $TeamEntityCopyWith<$Res> {
  factory _$$TeamEntityImplCopyWith(
          _$TeamEntityImpl value, $Res Function(_$TeamEntityImpl) then) =
      __$$TeamEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int playersCount, int score});
}

/// @nodoc
class __$$TeamEntityImplCopyWithImpl<$Res>
    extends _$TeamEntityCopyWithImpl<$Res, _$TeamEntityImpl>
    implements _$$TeamEntityImplCopyWith<$Res> {
  __$$TeamEntityImplCopyWithImpl(
      _$TeamEntityImpl _value, $Res Function(_$TeamEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? playersCount = null,
    Object? score = null,
  }) {
    return _then(_$TeamEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      playersCount: null == playersCount
          ? _value.playersCount
          : playersCount // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamEntityImpl extends _TeamEntity {
  const _$TeamEntityImpl(
      {required this.id,
      required this.name,
      this.playersCount = 2,
      this.score = 0})
      : super._();

  factory _$TeamEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final int playersCount;
  @override
  @JsonKey()
  final int score;

  @override
  String toString() {
    return 'TeamEntity(id: $id, name: $name, playersCount: $playersCount, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.playersCount, playersCount) ||
                other.playersCount == playersCount) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, playersCount, score);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamEntityImplCopyWith<_$TeamEntityImpl> get copyWith =>
      __$$TeamEntityImplCopyWithImpl<_$TeamEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamEntityImplToJson(
      this,
    );
  }
}

abstract class _TeamEntity extends TeamEntity {
  const factory _TeamEntity(
      {required final String id,
      required final String name,
      final int playersCount,
      final int score}) = _$TeamEntityImpl;
  const _TeamEntity._() : super._();

  factory _TeamEntity.fromJson(Map<String, dynamic> json) =
      _$TeamEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get playersCount;
  @override
  int get score;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamEntityImplCopyWith<_$TeamEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

