import '../entities/nem_a_pato_question_entity.dart';

/// Contrato da camada de dominio para o provedor de perguntas de estimativa.
abstract interface class NemAPatoQuestionRepository {
  /// Inicializa o banco de perguntas local em memoria.
  Future<void> initialize();

  /// Sorteia uma pergunta inedita, evitando IDs ja presentes em [usedQuestionIds].
  Future<NemAPatoQuestionEntity> drawQuestion({
    Set<String> usedQuestionIds = const {},
  });
}

