import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/team_entity.dart';
import '../state/game_notifier.dart';
import '../widgets/game_button.dart';

/// Tela 3: Scoreboard (Placar) - Exibe os termometros de pontuacao animados
/// com gradiente para cada equipe, destaca a equipe da vez e usa o GameButton 3D.
class ScoreboardPage extends ConsumerWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(gameNotifierProvider.select((s) => s.teams));
    final currentTeamIndex = ref.watch(
      gameNotifierProvider.select((s) => s.currentTeamIndex),
    );
    final targetScore = ref.watch(
      gameNotifierProvider.select((s) => s.targetScore),
    );
    final currentTeam = ref.watch(
      gameNotifierProvider.select((s) => s.currentTeam),
    );

    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('PLACAR DA PARTIDA'),
          leading: IconButton(
            tooltip: 'Sair para o Início',
            icon: const Icon(Icons.close_rounded, size: 28),
            onPressed: () => _confirmExitMatch(context, ref),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentYellow,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: AppTheme.accentYellowShadow,
                        offset: Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    'META: $targetScore PTS',
                    style: AppTheme.displayFont(
                      color: const Color(0xFF1F1235),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentTeam != null)
                  _CurrentTurnBanner(teamName: currentTeam.name),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: teams.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      final isCurrentTurn = index == currentTeamIndex;
                      return _ThermometerScoreCard(
                        team: team,
                        targetScore: targetScore,
                        isCurrentTurn: isCurrentTurn,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                GameButton(
                  label: currentTeam != null
                      ? 'INICIAR TURNO (${currentTeam.name.toUpperCase()})'
                      : 'INICIAR TURNO',
                  icon: Icons.casino_rounded,
                  buttonStyle: GameButtonStyle.yellow,
                  height: 66,
                  fontSize: 20,
                  depth: 7,
                  onPressed: () {
                    ref.read(gameNotifierProvider.notifier).startTurn();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmExitMatch(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Encerrar Partida?',
            style: AppTheme.displayFont(fontSize: 22),
          ),
          content: Text(
            'Deseja voltar ao menu inicial? O placar atual será perdido.',
            style: AppTheme.bodyFont(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'CONTINUAR',
                style: AppTheme.displayFont(
                  fontSize: 16,
                  color: AppTheme.infoCyan,
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: GameButton(
                label: 'SAIR',
                buttonStyle: GameButtonStyle.danger,
                height: 46,
                fontSize: 16,
                depth: 4,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ref.read(gameNotifierProvider.notifier).returnToHome();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CurrentTurnBanner extends StatelessWidget {
  final String teamName;

  const _CurrentTurnBanner({required this.teamName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryViolet,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.primaryVioletShadow,
            offset: Offset(0, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'PREPARE-SE! É A VEZ DA EQUIPE:',
            style: AppTheme.bodyFont(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            teamName.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTheme.displayFont(
              fontSize: 30,
              color: AppTheme.accentYellow,
              shadows: const [
                Shadow(
                  color: Colors.black38,
                  offset: Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThermometerScoreCard extends StatelessWidget {
  final TeamEntity team;
  final int targetScore;
  final bool isCurrentTurn;

  const _ThermometerScoreCard({
    required this.team,
    required this.targetScore,
    required this.isCurrentTurn,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (team.score / targetScore).clamp(0.0, 1.0);
    // Garante uma largura minima visivel na barra mesmo com 0 pontos
    final visualProgress = progress < 0.05 ? 0.05 : progress;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentTurn
            ? AppTheme.surfaceCardLight
            : AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isCurrentTurn
                ? AppTheme.primaryVioletShadow
                : const Color(0xFF160B36),
            offset: const Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCurrentTurn
                      ? AppTheme.accentYellow
                      : AppTheme.primaryViolet.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCurrentTurn
                      ? Icons.play_arrow_rounded
                      : Icons.groups_rounded,
                  color: isCurrentTurn
                      ? const Color(0xFF1F1235)
                      : Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: AppTheme.displayFont(
                        fontSize: 20,
                        color: isCurrentTurn
                            ? AppTheme.accentYellow
                            : Colors.white,
                      ),
                    ),
                    Text(
                      '${team.playersCount} jogadores',
                      style: AppTheme.bodyFont(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${team.score}',
                style: AppTheme.displayFont(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              Text(
                ' / $targetScore',
                style: AppTheme.displayFont(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Termometro de Pontuacao com Gradiente Animado
          Container(
            height: 18,
            width: double.infinity,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFF160B36),
              borderRadius: BorderRadius.circular(12),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fillWidth = constraints.maxWidth * visualProgress;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    width: fillWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      gradient: LinearGradient(
                        colors: isCurrentTurn
                            ? const [
                                AppTheme.warningOrange,
                                AppTheme.accentYellow,
                              ]
                            : const [
                                AppTheme.primaryViolet,
                                AppTheme.infoCyan,
                              ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
