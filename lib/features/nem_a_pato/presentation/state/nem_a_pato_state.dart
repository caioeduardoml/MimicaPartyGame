import '../../domain/entities/nem_a_pato_enums.dart';
import '../../domain/entities/nem_a_pato_player_entity.dart';
import '../../domain/entities/nem_a_pato_question_entity.dart';
import '../../domain/entities/player_round_result_entity.dart';

/// Estado imutavel completo do jogo "Nem a Pato".
class NemAPatoState {
  /// Fase atual que determina qual tela deve ser exibida.
  final NemAPatoPhase phase;

  /// Modo de jogo selecionado (Classico ou Secreto Pass-and-Play).
  final NemAPatoGameMode gameMode;

  /// Modo de definicao da punicao no Modo Secreto (Votacao ou Aleatoria).
  final PunishmentSelectionMode punishmentMode;

  /// Lista de jogadores participantes.
  final List<NemAPatoPlayerEntity> players;

  /// Indice do jogador cujo turno esta ativo no Modo Secreto.
  final int currentPlayerIndex;

  /// Pergunta ativa na rodada atual.
  final NemAPatoQuestionEntity? currentQuestion;

  /// Mapa de palpites ja calculados com a grandeza (Chave: player.id, Valor: double).
  final Map<String, double> playerGuesses;

  /// Mapa com o primeiro chute de cada jogador antes de acionar a Rodada Extra dos 80%.
  /// Permite mostrar exclusivamente para o jogador da vez quanto ele havia chutado antes.
  final Map<String, double> firstRoundGuesses;

  /// Mapa de votos de punicao registrados na rodada (Chave: player.id, Valor: PunishmentType).
  final Map<String, PunishmentType> punishmentVotes;

  /// Indica se a rodada atual ja utilizou a Rodada Extra da Regra dos 80% (limite: 1 por pergunta).
  final bool hasTriggeredExtraRound;

  /// Maior palpite registrado antes de acionar o alerta dos 80% (util para exibir no feedback).
  final double? highestGuessBeforeExtraRound;

  /// Punicao ativa/vencedora da rodada atual.
  final PunishmentType? activePunishment;

  /// Ranking final calculado ao encerrar a rodada no Modo Secreto.
  final List<PlayerRoundResultEntity> roundRanking;

  /// Conjunto de IDs de perguntas ja sorteadas para evitar repeticoes.
  final Set<String> usedQuestionIds;

  /// Mensagem de erro ou validacao (ex: numero invalido, falta de jogadores).
  final String? errorMessage;

  const NemAPatoState({
    this.phase = NemAPatoPhase.home,
    this.gameMode = NemAPatoGameMode.secret,
    this.punishmentMode = PunishmentSelectionMode.voting,
    this.players = const [],
    this.currentPlayerIndex = 0,
    this.currentQuestion,
    this.playerGuesses = const {},
    this.firstRoundGuesses = const {},
    this.punishmentVotes = const {},
    this.hasTriggeredExtraRound = false,
    this.highestGuessBeforeExtraRound,
    this.activePunishment,
    this.roundRanking = const [],
    this.usedQuestionIds = const {},
    this.errorMessage,
  });

  /// Retorna o jogador da vez no Modo Secreto, ou null se a lista for invalida.
  NemAPatoPlayerEntity? get currentPlayer {
    if (players.isEmpty ||
        currentPlayerIndex < 0 ||
        currentPlayerIndex >= players.length) {
      return null;
    }
    return players[currentPlayerIndex];
  }

  /// Limite maximo recomendado/permitido de jogadores conforme o modo.
  int get maxAllowedPlayers =>
      gameMode == NemAPatoGameMode.classic ? 15 : 8;

  /// Valida se a partida pode ser iniciada.
  /// No Modo Classico permite iniciar mesmo sem cadastrar nomes individuais,
  /// enquanto no Modo Secreto exige entre 2 e 15 jogadores (recomendado ate 8).
  bool get canStartGame {
    if (gameMode == NemAPatoGameMode.classic) {
      return true;
    }
    return players.length >= 2 &&
        players.length <= 15 &&
        players.every((p) => p.name.trim().isNotEmpty);
  }

  /// Lista filtrada apenas com os jogadores que sofreram a punicao na rodada.
  List<PlayerRoundResultEntity> get punishedPlayers =>
      roundRanking.where((r) => r.isPunished).toList(growable: false);

  /// Lista filtrada apenas com os jogadores que escaparam da punicao na rodada.
  List<PlayerRoundResultEntity> get sparedPlayers =>
      roundRanking.where((r) => !r.isPunished).toList(growable: false);

  NemAPatoState copyWith({
    NemAPatoPhase? phase,
    NemAPatoGameMode? gameMode,
    PunishmentSelectionMode? punishmentMode,
    List<NemAPatoPlayerEntity>? players,
    int? currentPlayerIndex,
    NemAPatoQuestionEntity? currentQuestion,
    bool clearCurrentQuestion = false,
    Map<String, double>? playerGuesses,
    Map<String, double>? firstRoundGuesses,
    Map<String, PunishmentType>? punishmentVotes,
    bool? hasTriggeredExtraRound,
    double? highestGuessBeforeExtraRound,
    bool clearHighestGuessBeforeExtraRound = false,
    PunishmentType? activePunishment,
    bool clearActivePunishment = false,
    List<PlayerRoundResultEntity>? roundRanking,
    Set<String> ? usedQuestionIds,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return NemAPatoState(
      phase: phase ?? this.phase,
      gameMode: gameMode ?? this.gameMode,
      punishmentMode: punishmentMode ?? this.punishmentMode,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      currentQuestion: clearCurrentQuestion
          ? null
          : (currentQuestion ?? this.currentQuestion),
      playerGuesses: playerGuesses ?? this.playerGuesses,
      firstRoundGuesses: firstRoundGuesses ?? this.firstRoundGuesses,
      punishmentVotes: punishmentVotes ?? this.punishmentVotes,
      hasTriggeredExtraRound:
          hasTriggeredExtraRound ?? this.hasTriggeredExtraRound,
      highestGuessBeforeExtraRound: clearHighestGuessBeforeExtraRound
          ? null
          : (highestGuessBeforeExtraRound ?? this.highestGuessBeforeExtraRound),
      activePunishment: clearActivePunishment
          ? null
          : (activePunishment ?? this.activePunishment),
      roundRanking: roundRanking ?? this.roundRanking,
      usedQuestionIds: usedQuestionIds ?? this.usedQuestionIds,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

