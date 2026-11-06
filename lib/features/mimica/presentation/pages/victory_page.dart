import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/team_entity.dart';
import '../state/game_notifier.dart';

/// Tela 7: Tela de Vitoria - Exibe o podio para a equipe vencedora
/// que atingiu a pontuacao maxima imediatamente e botao "Jogar Novamente".
class VictoryPage extends ConsumerWidget {
  const VictoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final winnerTeam = ref.watch(
      gameNotifierProvider.select((s) => s.winnerTeam),
    );
    final teams = ref.watch(
      gameNotifierProvider.select((s) => s.teams),
    );
    final targetScore = ref.watch(
      gameNotifierProvider.select((s) => s.targetScore),
    );

    final sortedTeams = List<TeamEntity>.from(teams)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              _WinnerPodiumHeader(
                winner: winnerTeam ?? sortedTeams.firstOrNull,
                targetScore: targetScore,
              ),
              const SizedBox(height: 24),
              const Text(
                'CLASSIFICAÇÃO FINAL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: sortedTeams.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final team = sortedTeams[index];
                    return _FinalRankingTile(
                      position: index + 1,
                      team: team,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(gameNotifierProvider.notifier).playAgainSameTeams();
                },
                icon: const Icon(Icons.replay_rounded, size: 28),
                label: const Text('JOGAR NOVAMENTE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(60),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(gameNotifierProvider.notifier).goToSetup();
                },
                icon: const Icon(Icons.settings_rounded),
                label: const Text('MUDAR EQUIPES / CONFIGURAÇÕES'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white38),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WinnerPodiumHeader extends StatelessWidget {
  final TeamEntity? winner;
  final int targetScore;

  const _WinnerPodiumHeader({
    required this.winner,
    required this.targetScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accentAmber, width: 3),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            size: 80,
            color: AppTheme.accentAmber,
          ),
          const SizedBox(height: 12),
          const Text(
            'VITÓRIA IMEDIATA!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
              color: AppTheme.accentAmber,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            winner?.name ?? 'Equipe Campeã',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${winner?.score ?? targetScore} pontos alcançados!',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.successGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalRankingTile extends StatelessWidget {
  final int position;
  final TeamEntity team;

  const _FinalRankingTile({
    required this.position,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    final isFirst = position == 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFirst ? AppTheme.accentAmber : Colors.white12,
          width: isFirst ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                isFirst ? AppTheme.accentAmber : Colors.white12,
            foregroundColor: isFirst ? Colors.black : Colors.white,
            child: Text(
              '#$position',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              team.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isFirst ? AppTheme.accentAmber : Colors.white,
              ),
            ),
          ),
          Text(
            '${team.score} pts',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

