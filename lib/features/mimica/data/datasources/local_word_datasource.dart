import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/words_database_model.dart';

/// Contrato para leitura da fonte de dados local de palavras.
abstract interface class LocalWordDataSource {
  Future<WordsDatabaseModel> loadWordsDatabase();
}

/// Implementacao que carrega e faz o parse do JSON empacotado nos assets.
class AssetWordDataSourceImpl implements LocalWordDataSource {
  static const String _assetPath = 'assets/data/words_db.json';
  WordsDatabaseModel? _cachedDatabase;

  @override
  Future<WordsDatabaseModel> loadWordsDatabase() async {
    if (_cachedDatabase != null) {
      return _cachedDatabase!;
    }

    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    _cachedDatabase = WordsDatabaseModel.fromJson(decoded);
    return _cachedDatabase!;
  }
}

