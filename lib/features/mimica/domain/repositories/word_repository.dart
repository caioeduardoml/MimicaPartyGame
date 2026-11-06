import '../entities/game_enums.dart';
import '../entities/mimic_card_entity.dart';

/// Contrato da camada de dominio para o provedor de cartas e palavras locais.
/// A implementacao concreta (via JSON nos assets) sera injetada na Parte 2.
abstract interface class WordRepository {
  /// Inicializa o banco de palavras em memoria a partir dos assets locais.
  Future<void> initialize();

  /// Sorteia e retorna uma carta de mimica de acordo com a [category] e o [riskLevel],
  /// evitando repetir palavras cujos IDs estejam em [usedCardIds].
  Future<MimicCardEntity> drawCard({
    required GameCategory category,
    required RiskLevel riskLevel,
    Set<String> usedCardIds = const {},
  });
}

