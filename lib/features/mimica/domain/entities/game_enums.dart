import 'package:json_annotation/json_annotation.dart';

/// Categorias disponiveis no Jogo de Mimica.
@JsonEnum(fieldRename: FieldRename.snake)
enum GameCategory {
  acoes('Ações'),
  objetos('Objetos'),
  lugares('Lugares'),
  animais('Animais'),
  verbos('Verbos'),
  filmes('Filmes'),
  herois('Heróis'),
  profissoes('Profissões'),
  esportes('Esportes'),
  comidas('Comidas'),
  cep('CEP (Cidade, Estado, País)'),
  dificilAleatorio('Difícil / Aleatório');

  final String label;
  const GameCategory(this.label);
}

/// Niveis de risco e pontuacao escolhidos pela equipe a cada turno.
///
/// Regras de negocio:
/// - Facil: +1 ponto se acertar, 0 se errar (1 palavra simples).
/// - Normal: +2 pontos se acertar, 0 se errar (1 palavra especifica).
/// - Dificil: +3 pontos se acertar, 0 se errar (2 palavras faceis combinadas).
/// - Bonus: +4 pontos se acertar, -2 pontos se errar (1 palavra normal + penalidade fisica).
enum RiskLevel {
  easy(
    label: 'Fácil',
    description: 'Uma palavra simples',
    pointsOnSuccess: 1,
    pointsOnFailure: 0,
  ),
  normal(
    label: 'Normal',
    description: 'Uma palavra específica',
    pointsOnSuccess: 2,
    pointsOnFailure: 0,
  ),
  hard(
    label: 'Difícil',
    description: 'Duas palavras combinadas',
    pointsOnSuccess: 3,
    pointsOnFailure: 0,
  ),
  bonus(
    label: 'Bônus',
    description: 'Palavra normal + Penalidade física (Erro: -2 pts)',
    pointsOnSuccess: 4,
    pointsOnFailure: -2,
  );

  final String label;
  final String description;
  final int pointsOnSuccess;
  final int pointsOnFailure;

  const RiskLevel({
    required this.label,
    required this.description,
    required this.pointsOnSuccess,
    required this.pointsOnFailure,
  });
}

/// Fases da maquina de estados que controla a navegacao e o fluxo da partida.
enum GamePhase {
  home,
  setup,
  scoreboard,
  categorySelection,
  riskSelection,
  preparationTimer,
  actionTimer,
  turnEvaluation,
  victory,
}

