import 'dart:math';

import '../../domain/entities/game_enums.dart';
import '../../domain/entities/mimic_card_entity.dart';
import '../../domain/repositories/word_repository.dart';
import '../datasources/local_word_datasource.dart';
import '../models/words_database_model.dart';

/// Implementacao concreta do repositorio de palavras alimentada por JSON nos assets.
///
/// Regras de negocio para geracao das cartas e NAO REPETICAO:
/// - [usedCardIds] guarda o conjunto de palavras ja sorteadas na partida.
/// - Uma palavra sorteada em qualquer turno (seja no Facil, Normal, Dificil ou Bonus)
///   nao se repete para nenhuma outra equipe durante a partida (a menos que todas as
///   palavras daquela categoria ja tenham sido esgotadas).
class WordRepositoryImpl implements WordRepository {
  final LocalWordDataSource _dataSource;
  final Random _random = Random();
  WordsDatabaseModel? _db;

  WordRepositoryImpl({required LocalWordDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<void> initialize() async {
    _db ??= await _dataSource.loadWordsDatabase();
  }

  @override
  Future<MimicCardEntity> drawCard({
    required GameCategory category,
    required RiskLevel riskLevel,
    Set<String> usedCardIds = const {},
  }) async {
    final db = _db ?? await _dataSource.loadWordsDatabase();
    _db = db;

    final categoryKey = _mapCategoryToJsonKey(category);
    final categoryWords = db.categories[categoryKey] ??
        db.categories.values.firstOrNull ??
        const CategoryWordsModel(
          easy: ['Faca', 'Celular'],
          normal: ['Copo de plástico'],
        );

    final effectiveWords = _resolveCategoryPool(db, category, categoryWords);

    switch (riskLevel) {
      case RiskLevel.easy:
        final word = _pickUnusedWord(
          pool: effectiveWords.easy,
          usedWords: usedCardIds,
        );
        return MimicCardEntity(
          id: word,
          category: category,
          riskLevel: riskLevel,
          primaryWord: word,
        );

      case RiskLevel.normal:
        final word = _pickUnusedWord(
          pool: effectiveWords.normal,
          usedWords: usedCardIds,
        );
        return MimicCardEntity(
          id: word,
          category: category,
          riskLevel: riskLevel,
          primaryWord: word,
        );

      case RiskLevel.hard:
        // Dificil (3 pontos): Duas palavras faceis combinadas e ineditas na partida
        final firstWord = _pickUnusedWord(
          pool: effectiveWords.easy,
          usedWords: usedCardIds,
        );

        final secondWord = _pickUnusedWord(
          pool: effectiveWords.easy,
          usedWords: {...usedCardIds, firstWord},
        );

        return MimicCardEntity(
          id: '$firstWord|$secondWord',
          category: category,
          riskLevel: riskLevel,
          primaryWord: firstWord,
          secondaryWord: secondWord,
        );

      case RiskLevel.bonus:
        // Bonus (4 pontos / -2 se errar): Uma palavra Normal inedita + Uma penalidade fisica
        final word = _pickUnusedWord(
          pool: effectiveWords.normal,
          usedWords: usedCardIds,
        );
        final penalties = db.penalties;
        final penalty = penalties.isNotEmpty
            ? penalties[_random.nextInt(penalties.length)]
            : 'Sem usar as mãos';

        return MimicCardEntity(
          id: word,
          category: category,
          riskLevel: riskLevel,
          primaryWord: word,
          physicalPenalty: penalty,
        );
    }
  }

  CategoryWordsModel _resolveCategoryPool(
    WordsDatabaseModel db,
    GameCategory category,
    CategoryWordsModel defaultPool,
  ) {
    if (category != GameCategory.dificilAleatorio) {
      return defaultPool;
    }
    final allEasy = <String>[];
    final allNormal = <String>[];
    for (final entry in db.categories.values) {
      allEasy.addAll(entry.easy);
      allNormal.addAll(entry.normal);
    }
    return CategoryWordsModel(
      easy: allEasy.isNotEmpty ? allEasy : defaultPool.easy,
      normal: allNormal.isNotEmpty ? allNormal : defaultPool.normal,
    );
  }

  /// Sorteia uma palavra do [pool] que ainda nao esteja presente em [usedWords].
  String _pickUnusedWord({
    required List<String> pool,
    required Set<String> usedWords,
  }) {
    if (pool.isEmpty) return 'Mímica Livre';

    final available = pool
        .where((word) => !usedWords.contains(word))
        .toList(growable: false);

    final targetList = available.isNotEmpty ? available : pool;
    return targetList[_random.nextInt(targetList.length)];
  }

  String _mapCategoryToJsonKey(GameCategory category) {
    return switch (category) {
      GameCategory.acoes => 'acoes',
      GameCategory.objetos => 'objetos',
      GameCategory.lugares => 'lugares',
      GameCategory.animais => 'animais',
      GameCategory.verbos => 'verbos',
      GameCategory.filmes => 'filmes',
      GameCategory.herois => 'herois',
      GameCategory.profissoes => 'profissoes',
      GameCategory.esportes => 'esportes',
      GameCategory.comidas => 'comidas',
      GameCategory.cep => 'cep',
      GameCategory.dificilAleatorio => 'dificil_aleatorio',
    };
  }
}
