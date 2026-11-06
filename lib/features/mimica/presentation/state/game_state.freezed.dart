// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameState {
  /// Fase atual do fluxo do jogo (controla qual tela deve ser exibida).
  GamePhase get phase => throw _privateConstructorUsedError;

  /// Lista de equipes participantes (minimo 2, maximo 6).
  List<TeamEntity> get teams => throw _privateConstructorUsedError;

  /// Indice da equipe que esta jogando o turno atual.
  int get currentTeamIndex => throw _privateConstructorUsedError;

  /// Pontuacao maxima para vencer a partida (configuravel via slider de 20 a 60).
  int get targetScore => throw _privateConstructorUsedError;

  /// Conjunto de categorias habilitadas pelo usuario no Setup (minimo 4).
  Set<GameCategory> get activeCategories => throw _privateConstructorUsedError;

  /// As 4 categorias sorteadas para a equipe escolher no turno atual.
  List<GameCategory> get drawnCategories => throw _privateConstructorUsedError;

  /// Categoria escolhida pela equipe da vez.
  GameCategory? get selectedCategory => throw _privateConstructorUsedError;

  /// Nivel de risco escolhido pela equipe da vez (Facil, Normal, Dificil ou Bonus).
  RiskLevel? get selectedRisk => throw _privateConstructorUsedError;

  /// Carta sorteada contendo a(s) palavra(s) e eventual penalidade fisica.
  MimicCardEntity? get currentCard => throw _privateConstructorUsedError;

  /// Tempo restante em segundos (5s na preparacao, 70s na acao).
  int get remainingSeconds => throw _privateConstructorUsedError;

  /// Indica se o cronometro esta pausado.
  bool get isTimerPaused => throw _privateConstructorUsedError;

  /// Equipe vencedora (preenchida imediatamente quando score >= targetScore).
  TeamEntity? get winnerTeam => throw _privateConstructorUsedError;

  /// Historico de IDs de cartas ja utilizadas na partida para evitar repeticoes.
  Set<String> get usedCardIds => throw _privateConstructorUsedError;

  /// Mensagem de erro ou validacao, caso ocorra.
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call(
      {GamePhase phase,
      List<TeamEntity> teams,
      int currentTeamIndex,
      int targetScore,
      Set<GameCategory> activeCategories,
      List<GameCategory> drawnCategories,
      GameCategory? selectedCategory,
      RiskLevel? selectedRisk,
      MimicCardEntity? currentCard,
      int remainingSeconds,
      bool isTimerPaused,
      TeamEntity? winnerTeam,
      Set<String> usedCardIds,
      String? errorMessage});

  $MimicCardEntityCopyWith<$Res>? get currentCard;
  $TeamEntityCopyWith<$Res>? get winnerTeam;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phase = null,
    Object? teams = null,
    Object? currentTeamIndex = null,
    Object? targetScore = null,
    Object? activeCategories = null,
    Object? drawnCategories = null,
    Object? selectedCategory = freezed,
    Object? selectedRisk = freezed,
    Object? currentCard = freezed,
    Object? remainingSeconds = null,
    Object? isTimerPaused = null,
    Object? winnerTeam = freezed,
    Object? usedCardIds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as GamePhase,
      teams: null == teams
          ? _value.teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamEntity>,
      currentTeamIndex: null == currentTeamIndex
          ? _value.currentTeamIndex
          : currentTeamIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetScore: null == targetScore
          ? _value.targetScore
          : targetScore // ignore: cast_nullable_to_non_nullable
              as int,
      activeCategories: null == activeCategories
          ? _value.activeCategories
          : activeCategories // ignore: cast_nullable_to_non_nullable
              as Set<GameCategory>,
      drawnCategories: null == drawnCategories
          ? _value.drawnCategories
          : drawnCategories // ignore: cast_nullable_to_non_nullable
              as List<GameCategory>,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as GameCategory?,
      selectedRisk: freezed == selectedRisk
          ? _value.selectedRisk
          : selectedRisk // ignore: cast_nullable_to_non_nullable
              as RiskLevel?,
      currentCard: freezed == currentCard
          ? _value.currentCard
          : currentCard // ignore: cast_nullable_to_non_nullable
              as MimicCardEntity?,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isTimerPaused: null == isTimerPaused
          ? _value.isTimerPaused
          : isTimerPaused // ignore: cast_nullable_to_non_nullable
              as bool,
      winnerTeam: freezed == winnerTeam
          ? _value.winnerTeam
          : winnerTeam // ignore: cast_nullable_to_non_nullable
              as TeamEntity?,
      usedCardIds: null == usedCardIds
          ? _value.usedCardIds
          : usedCardIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MimicCardEntityCopyWith<$Res>? get currentCard {
    if (_value.currentCard == null) {
      return null;
    }

    return $MimicCardEntityCopyWith<$Res>(_value.currentCard!, (value) {
      return _then(_value.copyWith(currentCard: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamEntityCopyWith<$Res>? get winnerTeam {
    if (_value.winnerTeam == null) {
      return null;
    }

    return $TeamEntityCopyWith<$Res>(_value.winnerTeam!, (value) {
      return _then(_value.copyWith(winnerTeam: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GamePhase phase,
      List<TeamEntity> teams,
      int currentTeamIndex,
      int targetScore,
      Set<GameCategory> activeCategories,
      List<GameCategory> drawnCategories,
      GameCategory? selectedCategory,
      RiskLevel? selectedRisk,
      MimicCardEntity? currentCard,
      int remainingSeconds,
      bool isTimerPaused,
      TeamEntity? winnerTeam,
      Set<String> usedCardIds,
      String? errorMessage});

  @override
  $MimicCardEntityCopyWith<$Res>? get currentCard;
  @override
  $TeamEntityCopyWith<$Res>? get winnerTeam;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phase = null,
    Object? teams = null,
    Object? currentTeamIndex = null,
    Object? targetScore = null,
    Object? activeCategories = null,
    Object? drawnCategories = null,
    Object? selectedCategory = freezed,
    Object? selectedRisk = freezed,
    Object? currentCard = freezed,
    Object? remainingSeconds = null,
    Object? isTimerPaused = null,
    Object? winnerTeam = freezed,
    Object? usedCardIds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$GameStateImpl(
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as GamePhase,
      teams: null == teams
          ? _value._teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamEntity>,
      currentTeamIndex: null == currentTeamIndex
          ? _value.currentTeamIndex
          : currentTeamIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetScore: null == targetScore
          ? _value.targetScore
          : targetScore // ignore: cast_nullable_to_non_nullable
              as int,
      activeCategories: null == activeCategories
          ? _value._activeCategories
          : activeCategories // ignore: cast_nullable_to_non_nullable
              as Set<GameCategory>,
      drawnCategories: null == drawnCategories
          ? _value._drawnCategories
          : drawnCategories // ignore: cast_nullable_to_non_nullable
              as List<GameCategory>,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as GameCategory?,
      selectedRisk: freezed == selectedRisk
          ? _value.selectedRisk
          : selectedRisk // ignore: cast_nullable_to_non_nullable
              as RiskLevel?,
      currentCard: freezed == currentCard
          ? _value.currentCard
          : currentCard // ignore: cast_nullable_to_non_nullable
              as MimicCardEntity?,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isTimerPaused: null == isTimerPaused
          ? _value.isTimerPaused
          : isTimerPaused // ignore: cast_nullable_to_non_nullable
              as bool,
      winnerTeam: freezed == winnerTeam
          ? _value.winnerTeam
          : winnerTeam // ignore: cast_nullable_to_non_nullable
              as TeamEntity?,
      usedCardIds: null == usedCardIds
          ? _value._usedCardIds
          : usedCardIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GameStateImpl extends _GameState {
  const _$GameStateImpl(
      {this.phase = GamePhase.home,
      final List<TeamEntity> teams = const [],
      this.currentTeamIndex = 0,
      this.targetScore = 30,
      final Set<GameCategory> activeCategories = const {
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
        GameCategory.dificilAleatorio
      },
      final List<GameCategory> drawnCategories = const [],
      this.selectedCategory,
      this.selectedRisk,
      this.currentCard,
      this.remainingSeconds = 0,
      this.isTimerPaused = false,
      this.winnerTeam,
      final Set<String> usedCardIds = const {},
      this.errorMessage})
      : _teams = teams,
        _activeCategories = activeCategories,
        _drawnCategories = drawnCategories,
        _usedCardIds = usedCardIds,
        super._();

  /// Fase atual do fluxo do jogo (controla qual tela deve ser exibida).
  @override
  @JsonKey()
  final GamePhase phase;

  /// Lista de equipes participantes (minimo 2, maximo 6).
  final List<TeamEntity> _teams;

  /// Lista de equipes participantes (minimo 2, maximo 6).
  @override
  @JsonKey()
  List<TeamEntity> get teams {
    if (_teams is EqualUnmodifiableListView) return _teams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teams);
  }

  /// Indice da equipe que esta jogando o turno atual.
  @override
  @JsonKey()
  final int currentTeamIndex;

  /// Pontuacao maxima para vencer a partida (configuravel via slider de 20 a 60).
  @override
  @JsonKey()
  final int targetScore;

  /// Conjunto de categorias habilitadas pelo usuario no Setup (minimo 4).
  final Set<GameCategory> _activeCategories;

  /// Conjunto de categorias habilitadas pelo usuario no Setup (minimo 4).
  @override
  @JsonKey()
  Set<GameCategory> get activeCategories {
    if (_activeCategories is EqualUnmodifiableSetView) return _activeCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_activeCategories);
  }

  /// As 4 categorias sorteadas para a equipe escolher no turno atual.
  final List<GameCategory> _drawnCategories;

  /// As 4 categorias sorteadas para a equipe escolher no turno atual.
  @override
  @JsonKey()
  List<GameCategory> get drawnCategories {
    if (_drawnCategories is EqualUnmodifiableListView) return _drawnCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_drawnCategories);
  }

  /// Categoria escolhida pela equipe da vez.
  @override
  final GameCategory? selectedCategory;

  /// Nivel de risco escolhido pela equipe da vez (Facil, Normal, Dificil ou Bonus).
  @override
  final RiskLevel? selectedRisk;

  /// Carta sorteada contendo a(s) palavra(s) e eventual penalidade fisica.
  @override
  final MimicCardEntity? currentCard;

  /// Tempo restante em segundos (5s na preparacao, 70s na acao).
  @override
  @JsonKey()
  final int remainingSeconds;

  /// Indica se o cronometro esta pausado.
  @override
  @JsonKey()
  final bool isTimerPaused;

  /// Equipe vencedora (preenchida imediatamente quando score >= targetScore).
  @override
  final TeamEntity? winnerTeam;

  /// Historico de IDs de cartas ja utilizadas na partida para evitar repeticoes.
  final Set<String> _usedCardIds;

  /// Historico de IDs de cartas ja utilizadas na partida para evitar repeticoes.
  @override
  @JsonKey()
  Set<String> get usedCardIds {
    if (_usedCardIds is EqualUnmodifiableSetView) return _usedCardIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_usedCardIds);
  }

  /// Mensagem de erro ou validacao, caso ocorra.
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'GameState(phase: $phase, teams: $teams, currentTeamIndex: $currentTeamIndex, targetScore: $targetScore, activeCategories: $activeCategories, drawnCategories: $drawnCategories, selectedCategory: $selectedCategory, selectedRisk: $selectedRisk, currentCard: $currentCard, remainingSeconds: $remainingSeconds, isTimerPaused: $isTimerPaused, winnerTeam: $winnerTeam, usedCardIds: $usedCardIds, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.phase, phase) || other.phase == phase) &&
            const DeepCollectionEquality().equals(other._teams, _teams) &&
            (identical(other.currentTeamIndex, currentTeamIndex) ||
                other.currentTeamIndex == currentTeamIndex) &&
            (identical(other.targetScore, targetScore) ||
                other.targetScore == targetScore) &&
            const DeepCollectionEquality()
                .equals(other._activeCategories, _activeCategories) &&
            const DeepCollectionEquality()
                .equals(other._drawnCategories, _drawnCategories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedRisk, selectedRisk) ||
                other.selectedRisk == selectedRisk) &&
            (identical(other.currentCard, currentCard) ||
                other.currentCard == currentCard) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.isTimerPaused, isTimerPaused) ||
                other.isTimerPaused == isTimerPaused) &&
            (identical(other.winnerTeam, winnerTeam) ||
                other.winnerTeam == winnerTeam) &&
            const DeepCollectionEquality()
                .equals(other._usedCardIds, _usedCardIds) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      phase,
      const DeepCollectionEquality().hash(_teams),
      currentTeamIndex,
      targetScore,
      const DeepCollectionEquality().hash(_activeCategories),
      const DeepCollectionEquality().hash(_drawnCategories),
      selectedCategory,
      selectedRisk,
      currentCard,
      remainingSeconds,
      isTimerPaused,
      winnerTeam,
      const DeepCollectionEquality().hash(_usedCardIds),
      errorMessage);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState extends GameState {
  const factory _GameState(
      {final GamePhase phase,
      final List<TeamEntity> teams,
      final int currentTeamIndex,
      final int targetScore,
      final Set<GameCategory> activeCategories,
      final List<GameCategory> drawnCategories,
      final GameCategory? selectedCategory,
      final RiskLevel? selectedRisk,
      final MimicCardEntity? currentCard,
      final int remainingSeconds,
      final bool isTimerPaused,
      final TeamEntity? winnerTeam,
      final Set<String> usedCardIds,
      final String? errorMessage}) = _$GameStateImpl;
  const _GameState._() : super._();

  /// Fase atual do fluxo do jogo (controla qual tela deve ser exibida).
  @override
  GamePhase get phase;

  /// Lista de equipes participantes (minimo 2, maximo 6).
  @override
  List<TeamEntity> get teams;

  /// Indice da equipe que esta jogando o turno atual.
  @override
  int get currentTeamIndex;

  /// Pontuacao maxima para vencer a partida (configuravel via slider de 20 a 60).
  @override
  int get targetScore;

  /// Conjunto de categorias habilitadas pelo usuario no Setup (minimo 4).
  @override
  Set<GameCategory> get activeCategories;

  /// As 4 categorias sorteadas para a equipe escolher no turno atual.
  @override
  List<GameCategory> get drawnCategories;

  /// Categoria escolhida pela equipe da vez.
  @override
  GameCategory? get selectedCategory;

  /// Nivel de risco escolhido pela equipe da vez (Facil, Normal, Dificil ou Bonus).
  @override
  RiskLevel? get selectedRisk;

  /// Carta sorteada contendo a(s) palavra(s) e eventual penalidade fisica.
  @override
  MimicCardEntity? get currentCard;

  /// Tempo restante em segundos (5s na preparacao, 70s na acao).
  @override
  int get remainingSeconds;

  /// Indica se o cronometro esta pausado.
  @override
  bool get isTimerPaused;

  /// Equipe vencedora (preenchida imediatamente quando score >= targetScore).
  @override
  TeamEntity? get winnerTeam;

  /// Historico de IDs de cartas ja utilizadas na partida para evitar repeticoes.
  @override
  Set<String> get usedCardIds;

  /// Mensagem de erro ou validacao, caso ocorra.
  @override
  String? get errorMessage;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

