import 'dart:math';

import '../../domain/entities/nem_a_pato_question_entity.dart';
import '../../domain/repositories/nem_a_pato_question_repository.dart';
import '../datasources/local_nem_a_pato_datasource.dart';

/// Implementacao concreta do repositorio de perguntas do "Nem a Pato".
/// Garante que nenhuma pergunta sorteada se repita enquanto houver perguntas ineditas no banco.
class NemAPatoQuestionRepositoryImpl implements NemAPatoQuestionRepository {
  final LocalNemAPatoDataSource _dataSource;
  final Random _random = Random();
  List<NemAPatoQuestionEntity>? _questions;

  NemAPatoQuestionRepositoryImpl({required LocalNemAPatoDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<void> initialize() async {
    _questions ??= await _dataSource.loadQuestions();
  }

  @override
  Future<NemAPatoQuestionEntity> drawQuestion({
    Set<String> usedQuestionIds = const {},
  }) async {
    final allQuestions = _questions ?? await _dataSource.loadQuestions();
    _questions = allQuestions;

    if (allQuestions.isEmpty) {
      return const NemAPatoQuestionEntity(
        id: 'fallback_default',
        theme: 'Curiosidades',
        questionText:
            'Qual é a distância aproximada em quilômetros da Terra até a Lua?',
        correctAnswer: 384400,
        formattedAnswer: '384,4 mil km',
      );
    }

    final unused = allQuestions
        .where((q) => !usedQuestionIds.contains(q.id))
        .toList(growable: false);

    final pool = unused.isNotEmpty ? unused : allQuestions;
    return pool[_random.nextInt(pool.length)];
  }
}

