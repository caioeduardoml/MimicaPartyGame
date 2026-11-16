import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/game_button.dart';
import '../state/nem_a_pato_notifier.dart';

/// Tela 3B (Transicao Pass-and-Play):
/// Exibe "Vez de [Jogador]. Nao deixe olharem!" e botao "ESTOU PRONTO".
/// Caso esteja na Rodada Extra (apos a regra dos 80%), destaca um selo de aviso.
class NemAPatoPassDevicePage extends ConsumerWidget {
  const NemAPatoPassDevicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlayer = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.currentPlayer),
    );
    final currentIndex = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.currentPlayerIndex),
    );
    final totalPlayers = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.players.length),
    );
    final isExtraRound = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.hasTriggeredExtraRound),
    );

    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('JOGADOR ${currentIndex + 1} DE $totalPlayers'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                ref.read(nemAPatoNotifierProvider.notifier).returnToHome();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isExtraRound)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.dangerRed,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppTheme.accentYellow,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'RODADA EXTRA (80%) — CHUTE MAIS ALTO!',
                            textAlign: TextAlign.center,
                            style: AppTheme.displayFont(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF150A33),
                        offset: Offset(0, 8),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentYellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.visibility_off_rounded,
                          size: 52,
                          color: Color(0xFF1F1235),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'PASSE O CELULAR PARA:',
                        style: AppTheme.bodyFont(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentPlayer?.name.toUpperCase() ?? 'JOGADOR',
                        textAlign: TextAlign.center,
                        style: AppTheme.displayFont(
                          fontSize: 38,
                          color: AppTheme.accentYellow,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Não deixe ninguém espiar a sua tela durante o seu chute secreto!',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyFont(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GameButton(
                  label: 'ESTOU PRONTO!',
                  icon: Icons.lock_open_rounded,
                  buttonStyle: GameButtonStyle.yellow,
                  height: 68,
                  fontSize: 22,
                  depth: 8,
                  onPressed: () {
                    ref
                        .read(nemAPatoNotifierProvider.notifier)
                        .confirmPlayerReadyForTurn();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

