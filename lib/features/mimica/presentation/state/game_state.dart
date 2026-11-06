import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/game_enums.dart';
import '../../domain/entities/mimic_card_entity.dart';
import '../../domain/entities/team_entity.dart';

part 'game_state.freezed.dart';

/// Estado global e imutavel da partida de Mimica.
@freezed
class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    /// Fase atual do fluxo do jogo (controla qual tela deve ser exibida).
    @Default(GamePhase.home) GamePhase phase,

    /// Lista de equipes participantes (minimo 2, maximo 6).
    @Default([]) List<TeamEntity> teams,

    /// Indice da equipe que esta jogando o turno atual.
    @Default(0) int currentTeamIndex,

    /// Pontuacao maxima para vencer a partida (configuravel via slider de 20 a 60).
    @Default(30) int targetScore,

    /// Conjunto de categorias habilitadas pelo usuario no Setup (minimo 4).
    @Default({
      GameCategory.acoes,
      GameCategory.objetos,
      GameCategory.lugares,
      GameCategory.animais,
      GameCategory.verbos,
      GameCategory.filmes,
      GameCategory.herois,
      GameCategory.profissoes,
      GameCategory.esportes,
      GameCategory.comidas,
      GameCategory.cep,
      GameCategory.dificilAleatorio,
    })
    Set<GameCategory> activeCategories,

    /// As 4 categorias sorteadas para a equipe escolher no turno atual.
    @Default([]) List<GameCategory> drawnCategories,

    /// Categoria escolhida pela equipe da vez.
    GameCategory? selectedCategory,

    /// Nivel de risco escolhido pela equipe da vez (Facil, Normal, Dificil ou Bonus).
    RiskLevel? selectedRisk,

    /// Carta sorteada contendo a(s) palavra(s) e eventual penalidade fisica.
    MimicCardEntity? currentCard,

    /// Tempo restante em segundos (5s na preparacao, 70s na acao).
    @Default(0) int remainingSeconds,

    /// Indica se o cronometro esta pausado.
    @Default(false) bool isTimerPaused,

    /// Equipe vencedora (preenchida imediatamente quando score >= targetScore).
    TeamEntity? winnerTeam,

    /// Historico de IDs de cartas ja utilizadas na partida para evitar repeticoes.
    @Default({}) Set<String> usedCardIds,

    /// Mensagem de erro ou validacao, caso ocorra.
    String? errorMessage,
  }) = _GameState;

  /// Retorna a equipe cujo turno esta ativo no momento, ou null se nao houver equipes.
  TeamEntity? get currentTeam {
    if (teams.isEmpty ||
        currentTeamIndex < 0 ||
        currentTeamIndex >= teams.length) {
      return null;
    }
    return teams[currentTeamIndex];
  }

  /// Valida se a configuracao da partida atende a todos os requisitos de negocio:
  /// - Entre 2 e 6 equipes.
  /// - Cada equipe com 2 a 6 jogadores e nome preenchido.
  /// - Pontuacao alvo entre 20 e 60 pontos.
  /// - Pelo menos 4 categorias ativas para permitir o sorteio de 4 opcoes.
  bool get canStartMatch {
    if (teams.length < 2 || teams.length > 6) return false;
    if (targetScore < 20 || targetScore > 60) return false;
    if (activeCategories.length < 4) return false;
    return teams.every(
      (team) => team.name.trim().isNotEmpty && team.hasValidPlayersCount,
    );
  }
}

