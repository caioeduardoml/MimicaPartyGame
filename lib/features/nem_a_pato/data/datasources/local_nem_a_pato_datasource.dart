import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/nem_a_pato_question_entity.dart';

/// Contrato para leitura das perguntas locais do "Nem a Pato".
abstract interface class LocalNemAPatoDataSource {
  Future<List<NemAPatoQuestionEntity>> loadQuestions();
}

/// Implementacao que carrega, valida e mantem em cache na RAM o arquivo `assets/data/nem_a_pato_db.json`.
class AssetNemAPatoDataSourceImpl implements LocalNemAPatoDataSource {
  static const String _assetPath = 'assets/data/nem_a_pato_db.json';
  List<NemAPatoQuestionEntity>? _cachedQuestions;

  @override
  Future<List<NemAPatoQuestionEntity>> loadQuestions() async {
    if (_cachedQuestions != null && _cachedQuestions!.isNotEmpty) {
      return _cachedQuestions!;
    }

    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Estrutura JSON do Nem a Pato invalida.');
      }

      final rawList = decoded['questions'];
      if (rawList is! List<dynamic>) {
        throw const FormatException('Lista de perguntas ausente ou invalida.');
      }

      // SEC-005: Valida schema e integridade numerica de cada pergunta carregada
      final validQuestions = rawList
          .whereType<Map<String, dynamic>>()
          .map(NemAPatoQuestionEntity.fromJson)
          .where(
            (q) =>
                q.id.trim().isNotEmpty &&
                q.questionText.trim().isNotEmpty &&
                !q.correctAnswer.isNaN &&
                !q.correctAnswer.isInfinite &&
                q.correctAnswer > 0,
          )
          .toList(growable: false);

      if (validQuestions.isNotEmpty) {
        _cachedQuestions = validQuestions;
        return _cachedQuestions!;
      }
    } catch (_) {
      // Prossegue para o fallback estatico abaixo
    }

    // Fallback defensivo caso o JSON seja corrompido
    _cachedQuestions = const [
      NemAPatoQuestionEntity(
        id: 'fallback_1',
        theme: 'Curiosidades',
        questionText: 'Quantos ossos tem o corpo humano adulto?',
        correctAnswer: 206,
        formattedAnswer: '206 ossos',
      ),
    ];
    return _cachedQuestions!;
  }
}
