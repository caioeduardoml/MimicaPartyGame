import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local_nem_a_pato_datasource.dart';
import '../../data/repositories/nem_a_pato_question_repository_impl.dart';
import '../../domain/entities/nem_a_pato_enums.dart';
import '../../domain/entities/nem_a_pato_player_entity.dart';
import '../../domain/entities/nem_a_pato_question_entity.dart';
import '../../domain/entities/player_round_result_entity.dart';
import '../../domain/repositories/nem_a_pato_question_repository.dart';
import 'nem_a_pato_state.dart';

/// Provider da fonte de dados local (leitura de `assets/data/nem_a_pato_db.json`).
final localNemAPatoDataSourceProvider =
    Provider<LocalNemAPatoDataSource>((ref) {
  return AssetNemAPatoDataSourceImpl();
});

/// Provider do repositorio de perguntas do "Nem a Pato" conectado ao JSON local.
final nemAPatoQuestionRepositoryProvider =
    Provider<NemAPatoQuestionRepository>((ref) {
  final dataSource = ref.watch(localNemAPatoDataSourceProvider);
  return NemAPatoQuestionRepositoryImpl(dataSource: dataSource);
});

/// Provider global do motor matematico e gerenciador de estado do "Nem a Pato".
final nemAPatoNotifierProvider =
    NotifierProvider<NemAPatoNotifier, NemAPatoState>(
  NemAPatoNotifier.new,
);

/// Motor principal do jogo "Nem a Pato".
/// Isola 100% da logica de negocio e matematica:
/// - Conversao de strings decimais + multiplicadores de grandeza (x1 ate Trilhão).
/// - Gerenciamento da fila de turnos no modo Pass-and-Play.
/// - Avaliacao da Trava Psicologica dos 80% (`maxGuess < 0.8 * correctAnswer`).
/// - Apuracao de votos de punicao (com desempate deterministico/aleatorio).
/// - Calculo do ranking por menor diferenca absoluta `abs(guess - correctAnswer)`
///   e determinacao exata de quem bebe e quem escapa.
class NemAPatoNotifier extends Notifier<NemAPatoState> {
  static const int minPlayers = 2;
  static const int maxPlayersClassic = 15;
  static const int recommendedMaxPlayersSecret = 8;
  static const int maxPlayerNameLength = 18;

  static final RegExp _unsafeControlCharsRegex = RegExp(
    r'[\x00-\x1F\x7F\u200B-\u200F\u202A-\u202E]',
  );

  final Random _random = _createSecureRandom();

  static Random _createSecureRandom() {
    try {
      return Random.secure();
    } catch (_) {
      return Random();
    }
  }

  /// Sanitiza nomes de jogadores removendo caracteres de controle/RTLO e truncando em 18 caracteres.
  static String sanitizePlayerName(String raw) {
    final cleaned = raw.replaceAll(_unsafeControlCharsRegex, '').trim();
    if (cleaned.length <= maxPlayerNameLength) return cleaned;
    return cleaned.substring(0, maxPlayerNameLength).trim();
  }

  @override
  NemAPatoState build() {
    return const NemAPatoState(
      players: [
        NemAPatoPlayerEntity(id: 'player_1', name: 'Jogador 1'),
        NemAPatoPlayerEntity(id: 'player_2', name: 'Jogador 2'),
        NemAPatoPlayerEntity(id: 'player_3', name: 'Jogador 3'),
      ],
    );
  }

  // ===========================================================================
  // 1. UTILITARIOS MATEMATICOS DE GRANDEZA E FORMATACAO
  // ===========================================================================

  /// Converte o texto digitado pelo usuario (suportando virgula ou ponto decimal)
  /// e multiplica pela grandeza selecionada ([NumberMagnitude]).
  ///
  /// Exemplo:
  /// - `rawInput: "2,5"`, `magnitude: NumberMagnitude.million` -> `2500000.0`
  /// Retorna `null` caso o input seja vazio, negativo ou invalido.
  static double? parseAndCalculateGuess({
    required String rawInput,
    required NumberMagnitude magnitude,
  }) {
    final sanitized = rawInput.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (sanitized.isEmpty) return null;

    final baseValue = double.tryParse(sanitized);
    if (baseValue == null || baseValue.isNaN || baseValue.isInfinite) {
      return null;
    }
    if (baseValue < 0) return null;

    return baseValue * magnitude.multiplier;
  }

  /// Formata um numero absoluto gigante (`double`) para leitura humana amigavel na UI.
  /// Ex: `2500000.0` -> `"2,5 milhões"`, `450.0` -> `"450"`.
  static String formatLargeNumber(double value) {
    final absVal = value.abs();
    if (absVal >= 1e12) {
      return '${_formatDecimal(value / 1e12)} trilhões';
    }
    if (absVal >= 1e9) {
      return '${_formatDecimal(value / 1e9)} bilhões';
    }
    if (absVal >= 1e6) {
      return '${_formatDecimal(value / 1e6)} milhões';
    }
    if (absVal >= 1e3) {
      return '${_formatDecimal(value / 1e3)} mil';
    }
    return _formatDecimal(value);
  }

  static String _formatDecimal(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '')
        .replaceAll('.', ',');
  }

  // ===========================================================================
  // 2. NAVEGACAO E CONFIGURACAO DA PARTIDA (SETUP)
  // ===========================================================================

  void goToSetup() {
    state = state.copyWith(
      phase: NemAPatoPhase.setup,
      clearErrorMessage: true,
    );
  }

  void returnToHome() {
    state = state.copyWith(
      phase: NemAPatoPhase.home,
      clearErrorMessage: true,
    );
  }

  void setGameMode(NemAPatoGameMode mode) {
    state = state.copyWith(
      gameMode: mode,
      clearErrorMessage: true,
    );
  }

  void setPunishmentSelectionMode(PunishmentSelectionMode mode) {
    state = state.copyWith(
      punishmentMode: mode,
      clearErrorMessage: true,
    );
  }

  void addPlayer(String name) {
    if (state.players.length >= maxPlayersClassic) {
      state = state.copyWith(
        errorMessage: 'Limite máximo de $maxPlayersClassic jogadores atingido.',
      );
      return;
    }

    final trimmed = sanitizePlayerName(name);
    final effectiveName = trimmed.isEmpty
        ? 'Jogador ${state.players.length + 1}'
        : trimmed;

    final newPlayer = NemAPatoPlayerEntity(
      id: 'player_${DateTime.now().microsecondsSinceEpoch}_${state.players.length}',
      name: effectiveName,
    );

    state = state.copyWith(
      players: [...state.players, newPlayer],
      clearErrorMessage: true,
    );
  }

  void updatePlayerName({required String playerId, required String newName}) {
    final trimmed = sanitizePlayerName(newName);
    if (trimmed.isEmpty) return;

    final updated = state.players.map((p) {
      return p.id == playerId ? p.copyWith(name: trimmed) : p;
    }).toList(growable: false);

    state = state.copyWith(players: updated, clearErrorMessage: true);
  }

  void removePlayer(String playerId) {
    if (state.players.length <= minPlayers) {
      state = state.copyWith(
        errorMessage: 'O jogo precisa de pelo menos $minPlayers jogadores.',
      );
      return;
    }

    final updated = state.players
        .where((p) => p.id != playerId)
        .toList(growable: false);

    state = state.copyWith(players: updated, clearErrorMessage: true);
  }

  /// Inicia o jogo e sorteia a primeira pergunta de acordo com o modo selecionado.
  Future<void> startGame() async {
    if (!state.canStartGame) {
      state = state.copyWith(
        errorMessage:
            'Cadastre pelo menos $minPlayers jogadores para iniciar o Modo Secreto.',
      );
      return;
    }

    await ref.read(nemAPatoQuestionRepositoryProvider).initialize();
    await startNextRound();
  }

  /// Sorteia uma nova pergunta e prepara o estado para uma nova rodada.
  Future<void> startNextRound() async {
    final repository = ref.read(nemAPatoQuestionRepositoryProvider);
    final question = await repository.drawQuestion(
      usedQuestionIds: state.usedQuestionIds,
    );

    final updatedUsedIds = {...state.usedQuestionIds, question.id};

    // Sorteia uma punicao base caso seja Modo Classico ou Modo Secreto Aleatorio
    final randomPunishment = PunishmentType
        .values[_random.nextInt(PunishmentType.values.length)];

    if (state.gameMode == NemAPatoGameMode.classic) {
      state = state.copyWith(
        currentQuestion: question,
        usedQuestionIds: updatedUsedIds,
        activePunishment: randomPunishment,
        playerGuesses: const {},
        firstRoundGuesses: const {},
        punishmentVotes: const {},
        roundRanking: const [],
        hasTriggeredExtraRound: false,
        clearHighestGuessBeforeExtraRound: true,
        phase: NemAPatoPhase.classicQuestion,
        clearErrorMessage: true,
      );
      return;
    }

    // Modo Secreto (Pass-and-Play)
    state = state.copyWith(
      currentQuestion: question,
      usedQuestionIds: updatedUsedIds,
      currentPlayerIndex: 0,
      playerGuesses: const {},
      firstRoundGuesses: const {},
      punishmentVotes: const {},
      roundRanking: const [],
      hasTriggeredExtraRound: false,
      clearHighestGuessBeforeExtraRound: true,
      activePunishment: state.punishmentMode == PunishmentSelectionMode.random
          ? randomPunishment
          : null,
      clearActivePunishment:
          state.punishmentMode == PunishmentSelectionMode.voting,
      phase: NemAPatoPhase.secretPassDevice,
      clearErrorMessage: true,
    );
  }

  // ===========================================================================
  // 3. FLUXO DO MODO CLASSICO (ABERTO / RAPIDO)
  // ===========================================================================

  /// Revela a resposta correta na tela do Modo Classico.
  void revealClassicAnswer() {
    if (state.phase != NemAPatoPhase.classicQuestion) return;
    state = state.copyWith(
      phase: NemAPatoPhase.classicReveal,
      clearErrorMessage: true,
    );
  }

  // ===========================================================================
  // 4. FLUXO DO MODO SECRETO (PASS-AND-PLAY) E REGRA DOS 80%
  // ===========================================================================

  /// Chamado na tela de transicao ("Vez de [Jogador]. Nao deixe olharem!")
  /// ao clicar em "Estou Pronto".
  void confirmPlayerReadyForTurn() {
    if (state.phase != NemAPatoPhase.secretPassDevice) return;
    state = state.copyWith(
      phase: NemAPatoPhase.secretPlayerTurn,
      clearErrorMessage: true,
    );
  }

  /// Registra o chute do jogador atual convertendo a string numerica + grandeza,
  /// computa o voto de punicao (quando aplicavel) e avanca o turno ou avalia o fim da rodada.
  void submitSecretTurn({
    required String rawNumberInput,
    required NumberMagnitude magnitude,
    PunishmentType? votedPunishment,
  }) {
    final activePlayer = state.currentPlayer;
    final question = state.currentQuestion;
    if (activePlayer == null || question == null) return;

    final calculatedGuess = parseAndCalculateGuess(
      rawInput: rawNumberInput,
      magnitude: magnitude,
    );

    if (calculatedGuess == null) {
      state = state.copyWith(
        errorMessage: 'Digite um valor numérico válido para confirmar o chute.',
      );
      return;
    }

    // No primeiro turno normal (quando a votacao esta ativa), exige selecionar 1 punicao
    final needsVote = state.punishmentMode == PunishmentSelectionMode.voting &&
        !state.hasTriggeredExtraRound;

    if (needsVote && votedPunishment == null) {
      state = state.copyWith(
        errorMessage: 'Selecione uma opção de punição antes de confirmar.',
      );
      return;
    }

    final updatedGuesses = Map<String, double>.from(state.playerGuesses)
      ..[activePlayer.id] = calculatedGuess;

    final updatedVotes = Map<String, PunishmentType>.from(state.punishmentVotes);
    if (votedPunishment != null && !state.hasTriggeredExtraRound) {
      updatedVotes[activePlayer.id] = votedPunishment;
    }

    final isLastPlayer = state.currentPlayerIndex >= state.players.length - 1;

    if (!isLastPlayer) {
      // Passa o aparelho para o proximo jogador da fila
      state = state.copyWith(
        playerGuesses: updatedGuesses,
        punishmentVotes: updatedVotes,
        currentPlayerIndex: state.currentPlayerIndex + 1,
        phase: NemAPatoPhase.secretPassDevice,
        clearErrorMessage: true,
      );
      return;
    }

    // Ultimo jogador finalizou o chute -> Avalia a Dinamica dos 80%
    _evaluateEndOfTurnGuesses(
      question: question,
      guesses: updatedGuesses,
      votes: updatedVotes,
    );
  }

  /// Avalia se o maior palpite da mesa atingiu pelo menos 80% da resposta correta.
  /// Se `maxGuess < 0.8 * correctAnswer` e ainda nao houve rodada extra nesta pergunta,
  /// engatilha a Rodada Extra mantendo os votos de punicao.
  void _evaluateEndOfTurnGuesses({
    required NemAPatoQuestionEntity question,
    required Map<String, double> guesses,
    required Map<String, PunishmentType> votes,
  }) {
    final maxGuess = guesses.values.isEmpty
        ? 0.0
        : guesses.values.reduce(max);

    final shouldTriggerEightyPercentRule = !state.hasTriggeredExtraRound &&
        question.correctAnswer > 0 &&
        maxGuess < question.eightyPercentThreshold;

    if (shouldTriggerEightyPercentRule) {
      state = state.copyWith(
        playerGuesses: guesses,
        firstRoundGuesses: Map<String, double>.unmodifiable(guesses),
        punishmentVotes: votes,
        hasTriggeredExtraRound: true,
        highestGuessBeforeExtraRound: maxGuess,
        phase: NemAPatoPhase.secretEightyPercentAlert,
        clearErrorMessage: true,
      );
      return;
    }

    // Caso tenham passado na trava dos 80% (ou ja estejam na rodada extra),
    // calcula a punicao vencedora e o ranking final.
    _finalizeSecretRound(
      question: question,
      guesses: guesses,
      votes: votes,
    );
  }

  /// Chamado apos o alerta vermelho dos 80% para reiniciar a fila de palpites
  /// para a mesma pergunta, preservando os votos de punicao ja feitos.
  void startExtraRoundAfterEightyPercentAlert() {
    if (state.phase != NemAPatoPhase.secretEightyPercentAlert) return;

    state = state.copyWith(
      currentPlayerIndex: 0,
      playerGuesses: const {},
      phase: NemAPatoPhase.secretPassDevice,
      clearErrorMessage: true,
    );
  }

  // ===========================================================================
  // 5. APURACAO DE VOTOS, CALCULO DE VITORIA E FAIXA DE PUNICAO
  // ===========================================================================

  void _finalizeSecretRound({
    required NemAPatoQuestionEntity question,
    required Map<String, double> guesses,
    required Map<String, PunishmentType> votes,
  }) {
    final winningPunishment = state.punishmentMode ==
            PunishmentSelectionMode.random
        ? (state.activePunishment ??
            PunishmentType.values[_random.nextInt(PunishmentType.values.length)])
        : _resolveWinningPunishment(votes);

    final ranking = _buildRoundRanking(
      players: state.players,
      guesses: guesses,
      votes: votes,
      correctAnswer: question.correctAnswer,
      punishment: winningPunishment,
    );

    // Atualiza estatisticas acumuladas dos jogadores na sessao
    final updatedPlayers = state.players.map((player) {
      final result = ranking.where((r) => r.player.id == player.id).firstOrNull;
      if (result == null) return player;
      return player.copyWith(
        roundsWon: result.isWinner ? player.roundsWon + 1 : player.roundsWon,
        punishmentsTaken: result.isPunished
            ? player.punishmentsTaken + 1
            : player.punishmentsTaken,
      );
    }).toList(growable: false);

    state = state.copyWith(
      players: updatedPlayers,
      playerGuesses: guesses,
      punishmentVotes: votes,
      activePunishment: winningPunishment,
      roundRanking: ranking,
      phase: NemAPatoPhase.secretRoundResult,
      clearErrorMessage: true,
    );
  }

  /// Apura a punicao mais votada pelos jogadores.
  /// Em caso de empate, sorteia entre as opcoes empatadas no topo.
  PunishmentType _resolveWinningPunishment(
    Map<String, PunishmentType> votes,
  ) {
    if (votes.isEmpty) {
      return PunishmentType.onlyWorstDrinks;
    }

    final counts = <PunishmentType, int>{};
    for (final vote in votes.values) {
      counts[vote] = (counts[vote] ?? 0) + 1;
    }

    int highestVoteCount = 0;
    for (final count in counts.values) {
      if (count > highestVoteCount) {
        highestVoteCount = count;
      }
    }

    final tiedWinners = counts.entries
        .where((entry) => entry.value == highestVoteCount)
        .map((entry) => entry.key)
        .toList(growable: false);

    return tiedWinners[_random.nextInt(tiedWinners.length)];
  }

  /// Ordena os jogadores pela menor diferenca absoluta `abs(Palpite - Resposta Correta)`
  /// e aplica a regra matematica da punicao vencedora para definir quem bebe.
  List<PlayerRoundResultEntity> _buildRoundRanking({
    required List<NemAPatoPlayerEntity> players,
    required Map<String, double> guesses,
    required Map<String, PunishmentType> votes,
    required double correctAnswer,
    required PunishmentType punishment,
  }) {
    if (players.isEmpty) return const [];

    // 1. Calcula a diferenca absoluta de cada jogador
    final rawEntries = players.map((player) {
      final guess = guesses[player.id] ?? 0.0;
      final diff = (guess - correctAnswer).abs();
      return (
        player: player,
        guess: guess,
        diff: diff,
        vote: votes[player.id],
      );
    }).toList();

    // 2. Ordena do menor erro (1º lugar) para o maior erro (ultimo lugar)
    rawEntries.sort((a, b) => a.diff.compareTo(b.diff));

    final totalPlayers = rawEntries.length;
    final smallestDiff = rawEntries.first.diff;

    // 3. Determina quantos jogadores na parte inferior do ranking sofrem a punicao
    final int punishedCountFromBottom = switch (punishment) {
      PunishmentType.onlyWorstDrinks => 1,
      PunishmentType.oneThirdDrinks => max(1, (totalPlayers / 3).ceil()),
      PunishmentType.halfDrinks => max(1, (totalPlayers / 2).ceil()),
      PunishmentType.onlyBestSpared => max(1, totalPlayers - 1),
    };

    final int firstPunishedIndex =
        max(1, totalPlayers - punishedCountFromBottom);

    // 4. Monta a lista final de resultados
    final results = <PlayerRoundResultEntity>[];
    for (var i = 0; i < totalPlayers; i++) {
      final item = rawEntries[i];
      final isWinner = item.diff == smallestDiff;

      // Na regra "So o melhor nao bebe", qualquer um que nao empatou em 1º lugar bebe.
      // Nas demais regras (1/3, metade, pior), entram os ultimos colocados da tabela.
      final bool isPunished;
      if (punishment == PunishmentType.onlyBestSpared) {
        isPunished = !isWinner || (totalPlayers > 1 && i >= firstPunishedIndex);
      } else {
        isPunished = i >= firstPunishedIndex;
      }

      results.add(
        PlayerRoundResultEntity(
          rankPosition: i + 1,
          player: item.player,
          guessValue: item.guess,
          absoluteDifference: item.diff,
          votedPunishment: item.vote,
          isWinner: isWinner,
          isPunished: isPunished,
        ),
      );
    }

    return results;
  }
}

