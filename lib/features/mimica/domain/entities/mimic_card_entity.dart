import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_enums.dart';

part 'mimic_card_entity.freezed.dart';
part 'mimic_card_entity.g.dart';

/// Representa a carta sorteada para a equipe realizar a mimica no turno atual.
///
/// - Nos riscos Facil, Normal e Bonus: [primaryWord] e preenchido e [secondaryWord] e nulo.
/// - No risco Dificil (3 pontos): [primaryWord] e [secondaryWord] sao preenchidos (2 palavras faceis combinadas).
/// - No risco Bonus (4 pontos / -2 se errar): [physicalPenalty] contem a restricao fisica obrigatoria.
@freezed
class MimicCardEntity with _$MimicCardEntity {
  const MimicCardEntity._();

  const factory MimicCardEntity({
    required String id,
    required GameCategory category,
    required RiskLevel riskLevel,
    required String primaryWord,
    String? secondaryWord,
    String? physicalPenalty,
  }) = _MimicCardEntity;

  factory MimicCardEntity.fromJson(Map<String, dynamic> json) =>
      _$MimicCardEntityFromJson(json);

  /// Retorna o texto formatado pronto para exibicao na Tela de Acao.
  String get displayText {
    final second = secondaryWord;
    if (second != null && second.trim().isNotEmpty) {
      return '$primaryWord e $second';
    }
    return primaryWord;
  }

  /// Indica se esta carta possui penalidade fisica ativa (exclusivo do nivel Bonus).
  bool get hasPenalty =>
      physicalPenalty != null && physicalPenalty!.trim().isNotEmpty;
}

