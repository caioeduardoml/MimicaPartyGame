import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/feedback_service.dart';
import '../../data/datasources/local_word_datasource.dart';
import '../../data/repositories/word_repository_impl.dart';
import '../../domain/entities/game_enums.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/repositories/word_repository.dart';
import 'game_state.dart';

/// Provider para o servico de feedbacks sonoros e hapticos.
final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  final service = FeedbackService();
  ref.onDispose(service.dispose);
  return service;
});

/// Provider da fonte de dados local (leitura do JSON nos assets).
final localWordDataSourceProvider = Provider<LocalWordDataSource>((ref) {
  return AssetWordDataSourceImpl();
});

/// Provider do repositorio de palavras conectado ao banco JSON nos assets.
final wordRepositoryProvider = Provider<WordRepository>((ref) {
  final dataSource = ref.watch(localWordDataSourceProvider);
  return WordRepositoryImpl(dataSource: dataSource);
});

/// Provider global do motor do jogo (GameNotifier).
final gameNotifierProvider = NotifierProvider<GameNotifier, GameState>(
  GameNotifier.new,
);

/// Motor principal do Jogo de Mimica.
/// Controla configuracao de equipes, sorteio de categorias, niveis de risco,
/// cronometros de preparacao (5s) e acao (70s), pontuacao e vitoria imediata.
class GameNotifier extends Notifier<GameState> {
  static const int minTeams = 2;
  static const int maxTeams = 6;
  static const int minPlayersPerTeam = 2;
  static const int maxPlayersPerTeam = 6;
  static const int minTargetScore = 20;
  static const int maxTargetScore = 60;
  static const int categoriesToDrawCount = 4;
  static const int preparationDurationSeconds = 5;
  static const int actionDurationSeconds = 70;

  Timer? _timer;
  final Random _random = Random();

  @override
  GameState build() {
    ref.onDispose(_cancelTimer);
    return const GameState(
      teams: [
        TeamEntity(id: 'team_1', name: 'Equipe 1', playersCount: 2),
        TeamEntity(id: 'team_2', name: 'Equipe 2', playersCount: 2),
      ],
    );
  }

  // ===========================================================================
  // 1. NAVEGACAO INICIAL E CONFIGURACAO DA PARTIDA (SETUP)
  // ===========================================================================

  /// Avanca da tela Home para a tela de Setup.
  void goToSetup() {
    _cancelTimer();
    state = state.copyWith(
      phase: GamePhase.setup,
      errorMessage: null,
    );
  }

  /// Retorna para a tela Home e limpa cronometros ativos.
  void returnToHome() {
    _cancelTimer();
    state = state.copyWith(
      phase: GamePhase.home,
      errorMessage: null,
    );
  }

  /// Define a pontuacao maxima para vencer (entre 20 e 60 pontos).
  void setTargetScore(int points) {
    final clamped = points.clamp(minTargetScore, maxTargetScore);
    state = state.copyWith(targetScore: clamped, errorMessage: null);
  }

  /// Alterna a ativacao de uma categoria no Setup.
  /// Garante que pelo menos 4 categorias permaneçam ativas para o sorteio.
  void toggleCategory(GameCategory category) {
    final currentSet = Set<GameCategory>.from(state.activeCategories);
    if (currentSet.contains(category)) {
      if (currentSet.length <= categoriesToDrawCount) {
        state = state.copyWith(
          errorMessage:
              'Mantenha pelo menos $categoriesToDrawCount categorias ativas para o sorteio.',
        );
        return;
      }
      currentSet.remove(category);
    } else {
      currentSet.add(category);
    }
    state = state.copyWith(
      activeCategories: currentSet,
      errorMessage: null,
    );
  }

  /// Adiciona uma nova equipe (respeitando o limite maximo de 6 equipes).
  void addTeam({required String name, int playersCount = 2}) {
    if (state.teams.length >= maxTeams) {
      state = state.copyWith(
        errorMessage: 'O limite máximo é de $maxTeams equipes.',
      );
      return;
    }

    final trimmedName = name.trim();
    final effectiveName =
        trimmedName.isEmpty ? 'Equipe ${state.teams.length + 1}' : trimmedName;
    final clampedPlayers =
        playersCount.clamp(minPlayersPerTeam, maxPlayersPerTeam);

    final newTeam = TeamEntity(
      id: 'team_${DateTime.now().microsecondsSinceEpoch}_${state.teams.length}',
      name: effectiveName,
      playersCount: clampedPlayers,
    );

    state = state.copyWith(
      teams: [...state.teams, newTeam],
      errorMessage: null,
    );
  }

  /// Atualiza o nome ou a quantidade de jogadores (2 a 6) de uma equipe existente.
  void updateTeam({
    required String teamId,
    String? name,
    int? playersCount,
  }) {
    final updatedTeams = state.teams.map((team) {
      if (team.id != teamId) return team;
      final newName = name != null ? name.trim() : team.name;
      final newPlayers = playersCount != null
          ? playersCount.clamp(minPlayersPerTeam, maxPlayersPerTeam)
          : team.playersCount;
      return team.copyWith(
        name: newName.isEmpty ? team.name : newName,
        playersCount: newPlayers,
      );
    }).toList();

    state = state.copyWith(teams: updatedTeams, errorMessage: null);
  }

  /// Remove uma equipe pelo ID (mantendo o minimo obrigatorio de 2 equipes).
  void removeTeam(String teamId) {
    if (state.teams.length <= minTeams) {
      state = state.copyWith(
        errorMessage: 'A partida precisa de no mínimo $minTeams equipes.',
      );
      return;
    }

    final updatedTeams =
        state.teams.where((team) => team.id != teamId).toList();
    state = state.copyWith(teams: updatedTeams, errorMessage: null);
  }

  /// Valida as configuracoes, zera os placares e inicia a partida indo para o Scoreboard.
  Future<void> startMatch() async {
    if (!state.canStartMatch) {
      state = state.copyWith(
        errorMessage:
            'Verifique se há entre 2 e 6 equipes (2 a 6 jogadores cada) e ao menos 4 categorias ativas.',
      );
      return;
    }

    await ref.read(wordRepositoryProvider).initialize();

    final resetTeams =
        state.teams.map((team) => team.copyWith(score: 0)).toList();

    state = state.copyWith(
      teams: resetTeams,
      currentTeamIndex: 0,
      winnerTeam: null,
      usedCardIds: const {},
      drawnCategories: const [],
      selectedCategory: null,
      selectedRisk: null,
      currentCard: null,
      phase: GamePhase.scoreboard,
      errorMessage: null,
    );
  }

  // ===========================================================================
  // 2. SORTEIO DE CATEGORIAS E SELECAO DE RISCO
  // ===========================================================================

  /// Chamado no Scoreboard ao clicar em "Iniciar Turno".
  /// Sorteia 4 categorias distintas dentre as categorias ativas e avanca para [GamePhase.categorySelection].
  void startTurn() {
    _cancelTimer();

    final pool = state.activeCategories.toList()..shuffle(_random);
    final drawn = pool.take(categoriesToDrawCount).toList();

    state = state.copyWith(
      drawnCategories: drawn,
      selectedCategory: null,
      selectedRisk: null,
      currentCard: null,
      phase: GamePhase.categorySelection,
      errorMessage: null,
    );
  }

  /// Registra a categoria escolhida pela equipe (dentre as 4 sorteadas)
  /// e avanca para a Tela de Risco ([GamePhase.riskSelection]).
  void selectCategory(GameCategory category) {
    state = state.copyWith(
      selectedCategory: category,
      phase: GamePhase.riskSelection,
      errorMessage: null,
    );
  }

  /// Registra o nivel de risco escolhido (Facil, Normal, Dificil ou Bonus),
  /// sorteia a carta correspondente no repositorio e inicia o Timer de Preparacao de 5 segundos
  /// com a palavra ja visivel na tela.
  Future<void> selectRiskAndStartPreparation(RiskLevel riskLevel) async {
    final category = state.selectedCategory;
    if (category == null) return;

    _cancelTimer();

    final repository = ref.read(wordRepositoryProvider);
    final card = await repository.drawCard(
      category: category,
      riskLevel: riskLevel,
      usedCardIds: state.usedCardIds,
    );

    final updatedUsedIds = {
      ...state.usedCardIds,
      card.primaryWord,
      if (card.secondaryWord != null) card.secondaryWord!,
    };

    state = state.copyWith(
      selectedRisk: riskLevel,
      currentCard: card,
      usedCardIds: updatedUsedIds,
      remainingSeconds: preparationDurationSeconds,
      isTimerPaused: false,
      phase: GamePhase.preparationTimer,
      errorMessage: null,
    );

    _startPreparationCountdown();
  }

  // ===========================================================================
  // 3. CONTROLE DOS TIMERS (PREPARACAO 5S -> ACAO 70S)
  // ===========================================================================

  void _startPreparationCountdown() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isTimerPaused || state.phase != GamePhase.preparationTimer) {
        return;
      }

      if (state.remainingSeconds > 1) {
        final nextSeconds = state.remainingSeconds - 1;
        state = state.copyWith(remainingSeconds: nextSeconds);
        ref.read(feedbackServiceProvider).playCountdownTick();
      } else {
        // Fim dos 5 segundos de preparacao -> Inicia automaticamente os 70s de acao
        _startActionCountdown();
      }
    });
  }

  void _startActionCountdown() {
    _cancelTimer();
    ref.read(feedbackServiceProvider).playStartAction();

    state = state.copyWith(
      phase: GamePhase.actionTimer,
      remainingSeconds: actionDurationSeconds,
      isTimerPaused: false,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isTimerPaused || state.phase != GamePhase.actionTimer) {
        return;
      }

      if (state.remainingSeconds > 1) {
        final nextSeconds = state.remainingSeconds - 1;
        state = state.copyWith(remainingSeconds: nextSeconds);

        // Feedback sutil nos ultimos 5 segundos da mimica
        if (nextSeconds <= 5) {
          ref.read(feedbackServiceProvider).playCountdownTick();
        }
      } else {
        // Tempo esgotado (0s): dispara alerta sonoro/haptico e exibe botoes Acertou / Errou
        _cancelTimer();
        ref.read(feedbackServiceProvider).playTimeUpAlert();
        state = state.copyWith(
          remainingSeconds: 0,
          isTimerPaused: false,
          phase: GamePhase.turnEvaluation,
        );
      }
    });
  }

  /// Pausa ou retoma o cronometro (funciona tanto na preparacao quanto nos 70s de acao).
  void togglePauseTimer() {
    if (state.phase != GamePhase.preparationTimer &&
        state.phase != GamePhase.actionTimer) {
      return;
    }
    state = state.copyWith(isTimerPaused: !state.isTimerPaused);
  }

  /// Permite encerrar a contagem regressiva antes dos 70 segundos caso a equipe
  /// ja tenha acertado ou desistido, levando aos botoes "Acertou" e "Errou".
  void finishActionTimerEarly() {
    if (state.phase != GamePhase.actionTimer &&
        state.phase != GamePhase.preparationTimer) {
      return;
    }
    _cancelTimer();
    state = state.copyWith(
      remainingSeconds: 0,
      isTimerPaused: false,
      phase: GamePhase.turnEvaluation,
    );
  }

  // ===========================================================================
  // 4. PONTUACAO, REGRA DO BONUS E CONDICAO DE VITORIA IMEDIATA
  // ===========================================================================

  /// Processa o resultado do turno ("Acertou" = [guessedCorrectly] true, "Errou" = false).
  ///
  /// Regras aplicadas:
  /// - Acertou: soma [RiskLevel.pointsOnSuccess] (+1, +2, +3 ou +4).
  /// - Errou: soma [RiskLevel.pointsOnFailure] (0 para Facil/Normal/Dificil, -2 para Bonus).
  /// - Condicao de Vitoria: Sem equilibrio de turnos. Se a equipe atingir `score >= targetScore`,
  ///   vence imediatamente e o jogo corta para [GamePhase.victory].
  void evaluateTurnResult({required bool guessedCorrectly}) {
    _cancelTimer();

    final risk = state.selectedRisk;
    final activeTeam = state.currentTeam;
    if (risk == null || activeTeam == null) return;

    final pointDelta =
        guessedCorrectly ? risk.pointsOnSuccess : risk.pointsOnFailure;

    // Impede que a pontuacao fique negativa caso erre no Bonus com 0 ou 1 ponto
    final updatedScore = max(0, activeTeam.score + pointDelta);
    final updatedTeam = activeTeam.copyWith(score: updatedScore);

    final updatedTeams = List<TeamEntity>.from(state.teams);
    updatedTeams[state.currentTeamIndex] = updatedTeam;

    // Verifica condicao de vitoria imediata (sem equilibrio de turnos)
    if (updatedScore >= state.targetScore) {
      ref.read(feedbackServiceProvider).playVictoryAlert();
      state = state.copyWith(
        teams: updatedTeams,
        winnerTeam: updatedTeam,
        phase: GamePhase.victory,
        errorMessage: null,
      );
      return;
    }

    // Passa a vez para a proxima equipe e retorna para o Placar (Scoreboard)
    final nextTeamIndex = (state.currentTeamIndex + 1) % updatedTeams.length;

    state = state.copyWith(
      teams: updatedTeams,
      currentTeamIndex: nextTeamIndex,
      drawnCategories: const [],
      selectedCategory: null,
      selectedRisk: null,
      currentCard: null,
      remainingSeconds: 0,
      isTimerPaused: false,
      phase: GamePhase.scoreboard,
      errorMessage: null,
    );
  }

  // ===========================================================================
  // 5. REINICIO DE PARTIDA (JOGAR NOVAMENTE)
  // ===========================================================================

  /// Reinicia a partida mantendo as mesmas equipes e configuracoes de pontos/categorias,
  /// zerando os placares e voltando ao Scoreboard.
  void playAgainSameTeams() {
    _cancelTimer();

    final resetTeams =
        state.teams.map((team) => team.copyWith(score: 0)).toList();

    state = state.copyWith(
      teams: resetTeams,
      currentTeamIndex: 0,
      winnerTeam: null,
      drawnCategories: const [],
      selectedCategory: null,
      selectedRisk: null,
      currentCard: null,
      remainingSeconds: 0,
      isTimerPaused: false,
      phase: GamePhase.scoreboard,
      errorMessage: null,
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

