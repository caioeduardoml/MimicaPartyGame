import 'nem_a_pato_enums.dart';
import 'nem_a_pato_player_entity.dart';

/// Representa a posicao e o desempenho de um jogador no ranking final da rodada.
class PlayerRoundResultEntity {
  final int rankPosition;
  final NemAPatoPlayerEntity player;
  final double guessValue;
  final double absoluteDifference;
  final PunishmentType? votedPunishment;
  final bool isWinner;
  final bool isPunished;

  const PlayerRoundResultEntity({
    required this.rankPosition,
    required this.player,
    required this.guessValue,
    required this.absoluteDifference,
    required this.isWinner,
    required this.isPunished,
    this.votedPunishment,
  });
}

