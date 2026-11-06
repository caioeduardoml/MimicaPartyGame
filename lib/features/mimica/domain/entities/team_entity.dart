import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_entity.freezed.dart';
part 'team_entity.g.dart';

/// Representa uma equipe participante da partida.
/// Suporta de 2 a 6 equipes na partida, e cada equipe comporta de 2 a 6 jogadores.
@freezed
class TeamEntity with _$TeamEntity {
  const TeamEntity._();

  const factory TeamEntity({
    required String id,
    required String name,
    @Default(2) int playersCount,
    @Default(0) int score,
  }) = _TeamEntity;

  factory TeamEntity.fromJson(Map<String, dynamic> json) =>
      _$TeamEntityFromJson(json);

  /// Valida se a quantidade de jogadores da equipe respeita a regra (2 a 6).
  bool get hasValidPlayersCount => playersCount >= 2 && playersCount <= 6;
}

