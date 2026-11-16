/// Representa uma pergunta de estimativa numerica do jogo "Nem a Pato".
class NemAPatoQuestionEntity {
  final String id;
  final String theme;
  final String questionText;
  final double correctAnswer;
  final String formattedAnswer;
  final String? curiosityNote;

  const NemAPatoQuestionEntity({
    required this.id,
    required this.theme,
    required this.questionText,
    required this.correctAnswer,
    required this.formattedAnswer,
    this.curiosityNote,
  });

  factory NemAPatoQuestionEntity.fromJson(Map<String, dynamic> json) {
    return NemAPatoQuestionEntity(
      id: json['id']?.toString() ?? '',
      theme: json['theme']?.toString() ?? 'Curiosidades',
      questionText: json['questionText']?.toString() ?? '',
      correctAnswer: (json['correctAnswer'] as num?)?.toDouble() ?? 0.0,
      formattedAnswer: json['formattedAnswer']?.toString() ?? '0',
      curiosityNote: json['curiosityNote']?.toString(),
    );
  }

  /// Retorna o limite minimo exigido pela regra psicologica dos 80% (`0.8 * correctAnswer`).
  double get eightyPercentThreshold => correctAnswer * 0.8;
}

