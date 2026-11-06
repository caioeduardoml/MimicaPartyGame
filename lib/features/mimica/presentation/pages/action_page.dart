import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/game_enums.dart';
import '../../domain/entities/mimic_card_entity.dart';
import '../state/game_notifier.dart';

/// Tela 6: Tela de Acao - Exibe:
/// - A(s) palavra(s) sorteada(s)
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

class _WordDisplayCard extends StatelessWidget {
  final MimicCardEntity card;

  const _WordDisplayCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  card.category.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.infoCyan,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${card.riskLevel.label.toUpperCase()} (+${card.riskLevel.pointsOnSuccess} pts)',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentAmber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          if (card.hasPenalty) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
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
                      fontSize: 18,
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

