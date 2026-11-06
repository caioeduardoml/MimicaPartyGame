import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/game_enums.dart';
import '../state/game_notifier.dart';
import 'action_page.dart';
import 'category_selection_page.dart';
import 'home_page.dart';
import 'risk_selection_page.dart';
import 'scoreboard_page.dart';
import 'setup_page.dart';
import 'victory_page.dart';

/// Controlador declarativo de telas baseado na fase atual do [GameState].
/// Garante transicoes suaves e reativas sem acoplamento de rotas manuais.
class GameFlowShellPage extends ConsumerWidget {
  const GameFlowShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(gameNotifierProvider.select((s) => s.phase));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      child: switch (phase) {
        GamePhase.home => const HomePage(key: ValueKey('home')),
        GamePhase.setup => const SetupPage(key: ValueKey('setup')),
        GamePhase.scoreboard =>
          const ScoreboardPage(key: ValueKey('scoreboard')),
        GamePhase.categorySelection =>
          const CategorySelectionPage(key: ValueKey('categorySelection')),
        GamePhase.riskSelection =>
          const RiskSelectionPage(key: ValueKey('riskSelection')),
        GamePhase.preparationTimer ||
        GamePhase.actionTimer ||
        GamePhase.turnEvaluation =>
          const ActionPage(key: ValueKey('actionPage')),
        GamePhase.victory => const VictoryPage(key: ValueKey('victory')),
      },
    );
  }
}

