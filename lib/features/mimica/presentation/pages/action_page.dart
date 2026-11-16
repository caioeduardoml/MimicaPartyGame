import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/game_enums.dart';
import '../../domain/entities/mimic_card_entity.dart';
import '../state/game_notifier.dart';

/// Tela 6: Tela de Acao - Exibe:
/// - A(s) palavra(s) sorteada(s) com botao de olho no canto para virar a carta de costas e ocultar a resposta
/// - O modificador/penalidade fisica (se for Bonus)
/// - O Timer Gigante (5s de preparacao -> 70s de mimica)
/// - Botao de Pausar/Retomar
/// - Ao final do tempo (ou encerrar turno), exibe os botoes "ACERTOU" e "ERROU"
class ActionPage extends ConsumerWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(gameNotifierProvider.select((s) => s.phase));
    final currentCard = ref.watch(
      gameNotifierProvider.select((s) => s.currentCard),
    );
    final remainingSeconds = ref.watch(
      gameNotifierProvider.select((s) => s.remainingSeconds),
    );
    final isPaused = ref.watch(
      gameNotifierProvider.select((s) => s.isTimerPaused),
    );

    if (currentCard == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isPrep = phase == GamePhase.preparationTimer;
    final isEvaluation = phase == GamePhase.turnEvaluation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPrep
              ? 'PREPARE-SE!'
              : isEvaluation
                  ? 'TEMPO ESGOTADO!'
                  : 'VALENDO MÍMICA!',
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WordDisplayCard(card: currentCard),
              const Spacer(),
              _GiantTimerWidget(
                phase: phase,
                remainingSeconds: remainingSeconds,
                isPaused: isPaused,
              ),
              const Spacer(),
              if (isEvaluation)
                _TurnEvaluationButtons(riskLevel: currentCard.riskLevel)
              else
                _TimerControlButtons(
                  isPaused: isPaused,
                  isPrep: isPrep,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordDisplayCard extends StatefulWidget {
  final MimicCardEntity card;

  const _WordDisplayCard({required this.card});

  @override
  State<_WordDisplayCard> createState() => _WordDisplayCardState();
}

class _WordDisplayCardState extends State<_WordDisplayCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutBack,
    );
  }

  @override
  void didUpdateWidget(covariant _WordDisplayCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se trocar de carta para uma nova rodada, garante que comece virada para frente
    if (oldWidget.card != widget.card && _isObscured) {
      _isObscured = false;
      _flipController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlipCard() {
    setState(() {
      _isObscured = !_isObscured;
      if (_isObscured) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, _) {
        final angle = _flipAnimation.value * math.pi;
        final isShowingBack = angle >= (math.pi / 2);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angle),
          child: isShowingBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: _buildBackSide(),
                )
              : _buildFrontSide(),
        );
      },
    );
  }

  Widget _buildFrontSide() {
    final card = widget.card;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: card.hasPenalty ? AppTheme.dangerRed : AppTheme.primaryPurple,
          width: 2.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        card.category.label.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.infoCyan,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentAmber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${card.riskLevel.label.toUpperCase()} (+${card.riskLevel.pointsOnSuccess} pts)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentAmber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildEyeToggleButton(isObscured: false),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'SUA MÍMICA É:',
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.displayText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          if (card.hasPenalty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.dangerRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.dangerRed),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppTheme.dangerRed,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'PENALIDADE FÍSICA (BÔNUS)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.dangerRed,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    card.physicalPenalty!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    final card = widget.card;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF391E7A),
            Color(0xFF1F1147),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accentYellow.withValues(alpha: 0.8),
          width: 2.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        card.category.label.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.infoCyan,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${card.riskLevel.label.toUpperCase()} (+${card.riskLevel.pointsOnSuccess} pts)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentAmber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildEyeToggleButton(isObscured: true),
            ],
          ),
          const SizedBox(height: 22),
          const Icon(
            Icons.visibility_off_rounded,
            size: 42,
            color: AppTheme.accentYellow,
          ),
          const SizedBox(height: 10),
          Text(
            'CARTA VIRADA (OCULTA)',
            textAlign: TextAlign.center,
            style: AppTheme.displayFont(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Toque no olho no canto da carta para ver a resposta novamente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEyeToggleButton({required bool isObscured}) {
    return Material(
      color: isObscured
          ? AppTheme.accentYellow
          : Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _toggleFlipCard,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isObscured
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 20,
                color: isObscured ? const Color(0xFF1F1235) : Colors.white,
              ),
              const SizedBox(width: 5),
              Text(
                isObscured ? 'VER' : 'OCULTAR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: isObscured ? const Color(0xFF1F1235) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GiantTimerWidget extends StatelessWidget {
  final GamePhase phase;
  final int remainingSeconds;
  final bool isPaused;

  const _GiantTimerWidget({
    required this.phase,
    required this.remainingSeconds,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    final isPrep = phase == GamePhase.preparationTimer;
    final isEvaluation = phase == GamePhase.turnEvaluation;

    final maxSeconds = isPrep
        ? GameNotifier.preparationDurationSeconds
        : GameNotifier.actionDurationSeconds;
    final progress =
        maxSeconds > 0 ? (remainingSeconds / maxSeconds).clamp(0.0, 1.0) : 0.0;

    final ringColor = isEvaluation
        ? AppTheme.dangerRed
        : isPrep
            ? AppTheme.accentAmber
            : remainingSeconds <= 10
                ? AppTheme.dangerRed
                : AppTheme.successGreen;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isPrep
              ? 'PREPARAÇÃO (OLHE A PALAVRA)'
              : isEvaluation
                  ? 'A EQUIPE ACERTOU A MÍMICA?'
                  : isPaused
                      ? 'CRONÔMETRO PAUSADO'
                      : 'TEMPO CORRENDO',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: ringColor,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 210,
          height: 210,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: isEvaluation ? 1.0 : progress,
                strokeWidth: 14,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(ringColor),
              ),
              Center(
                child: Text(
                  '$remainingSeconds',
                  style: TextStyle(
                    fontSize: 76,
                    fontWeight: FontWeight.w900,
                    color: isPaused ? Colors.white54 : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimerControlButtons extends ConsumerWidget {
  final bool isPaused;
  final bool isPrep;

  const _TimerControlButtons({
    required this.isPaused,
    required this.isPrep,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).togglePauseTimer();
          },
          icon: Icon(
            isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            size: 28,
          ),
          label: Text(isPaused ? 'RETOMAR TEMPO' : 'PAUSAR TEMPO'),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isPaused ? AppTheme.successGreen : AppTheme.surfaceCard,
            foregroundColor: isPaused ? Colors.black : Colors.white,
            side: const BorderSide(color: Colors.white24),
          ),
        ),
        if (!isPrep) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              ref.read(gameNotifierProvider.notifier).finishActionTimerEarly();
            },
            icon: const Icon(Icons.done_all_rounded, color: AppTheme.accentAmber),
            label: const Text(
              'JÁ ACERTARAM / ENCERRAR TEMPO AGORA',
              style: TextStyle(
                color: AppTheme.accentAmber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TurnEvaluationButtons extends ConsumerWidget {
  final RiskLevel riskLevel;

  const _TurnEvaluationButtons({required this.riskLevel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failPoints = riskLevel.pointsOnFailure;
    final failLabel =
        failPoints < 0 ? 'ERROU ($failPoints PTS)' : 'ERROU (0 PTS)';

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ref
                  .read(gameNotifierProvider.notifier)
                  .evaluateTurnResult(guessedCorrectly: false);
            },
            icon: const Icon(Icons.close_rounded, size: 28),
            label: Text(failLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerRed,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(64),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ref
                  .read(gameNotifierProvider.notifier)
                  .evaluateTurnResult(guessedCorrectly: true);
            },
            icon: const Icon(Icons.check_rounded, size: 28),
            label: Text('ACERTOU (+${riskLevel.pointsOnSuccess})'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(64),
            ),
          ),
        ),
      ],
    );
  }
}
