import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/words_database_model.dart';

/// Contrato para leitura da fonte de dados local de palavras.
abstract interface class LocalWordDataSource {
  Future<WordsDatabaseModel> loadWordsDatabase();
}

/// Implementacao que carrega e faz o parse seguro do JSON empacotado nos assets.
class AssetWordDataSourceImpl implements LocalWordDataSource {
  static const String _assetPath = 'assets/data/words_db.json';
  WordsDatabaseModel? _cachedDatabase;

  @override
  Future<WordsDatabaseModel> loadWordsDatabase() async {
    if (_cachedDatabase != null) {
      return _cachedDatabase!;
    }

    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Estrutura JSON de palavras invalida.');
      }

      _cachedDatabase = WordsDatabaseModel.fromJson(decoded);
      return _cachedDatabase!;
    } catch (_) {
      // SEC-005: Fallback defensivo para evitar crash (DoS) caso o asset seja corrompido
      _cachedDatabase = const WordsDatabaseModel(
        penalties: [],
        categories: {},
      );
      return _cachedDatabase!;
    }
  }
}
