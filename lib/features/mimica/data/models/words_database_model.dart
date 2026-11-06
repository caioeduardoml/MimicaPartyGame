/// Modelo que armazena as listas de palavras Faceis e Normais de uma categoria.
class CategoryWordsModel {
  final List<String> easy;
  final List<String> normal;

  const CategoryWordsModel({
    required this.easy,
    required this.normal,
  });

  factory CategoryWordsModel.fromJson(Map<String, dynamic> json) {
    final easyList = (json['easy'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(growable: false);
    final normalList = (json['normal'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(growable: false);

    return CategoryWordsModel(
      easy: easyList,
      normal: normalList,
    );
  }
}

/// Modelo completo do banco de dados local carregado de `assets/data/words_db.json`.
class WordsDatabaseModel {
  final List<String> penalties;
  final Map<String, CategoryWordsModel> categories;

  const WordsDatabaseModel({
    required this.penalties,
    required this.categories,
  });

  factory WordsDatabaseModel.fromJson(Map<String, dynamic> json) {
    final penaltiesList = (json['penalties'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(growable: false);

    final rawCategories =
        json['categories'] as Map<String, dynamic>? ?? const {};
    final parsedCategories = <String, CategoryWordsModel>{};

    for (final entry in rawCategories.entries) {
      if (entry.value is Map<String, dynamic>) {
        parsedCategories[entry.key] = CategoryWordsModel.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }

    return WordsDatabaseModel(
      penalties: penaltiesList,
      categories: parsedCategories,
    );
  }
}

