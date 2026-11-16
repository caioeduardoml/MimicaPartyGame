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

    /// Quantidade de turnos ja concluidos por esta equipe na partida atual.
    @Default(0) int turnsPlayed,

    /// Indice do proximo turno desta equipe em que o Desafio Bonus sera obrigatorio.
    @Default(2) int nextMandatoryBonusTurn,

    /// Fila embaralhada de integrantes (1..playersCount) que ainda nao cairam no Bonus Obrigatorio.
    @Default([]) List<int> pendingBonusPlayers,
  }) = _TeamEntity;

  factory TeamEntity.fromJson(Map<String, dynamic> json) =>
      _$TeamEntityFromJson(json);

  /// Valida se a quantidade de jogadores da equipe respeita a regra (2 a 6).
  bool get hasValidPlayersCount => playersCount >= 2 && playersCount <= 6;

  /// Numero do integrante da equipe que vai fazer a mimica no turno atual (1 a playersCount).
  int get currentPlayerNumber => (turnsPlayed % playersCount) + 1;

  /// Indica se o turno atual desta equipe e uma rodada de Desafio Bonus Obrigatorio.
  bool get isMandatoryBonusTurn => turnsPlayed >= nextMandatoryBonusTurn;

  /// Quantos turnos faltam para o proximo Desafio Bonus Obrigatorio desta equipe (0 se for agora).
  int get turnsUntilMandatoryBonus {
    final diff = nextMandatoryBonusTurn - turnsPlayed;
    return diff < 0 ? 0 : diff;
  }
}

