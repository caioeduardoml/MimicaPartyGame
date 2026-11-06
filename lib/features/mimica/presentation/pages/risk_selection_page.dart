import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/game_enums.dart';
import '../state/game_notifier.dart';

/// Tela 5: Selecao de Risco - Exibe os botoes Facil (1 pt), Normal (2 pts),
/// Dificil (3 pts) e Bonus (4 pts / -2 pts se errar).
class RiskSelectionPage extends ConsumerWidget {
  const RiskSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(
      gameNotifierProvider.select((s) => s.selectedCategory),
    );
    final currentTeam = ref.watch(
      gameNotifierProvider.select((s) => s.currentTeam),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('NÍVEL DE RISCO'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Equipe: ${currentTeam?.name ?? ""}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Categoria: ${selectedCategory?.label ?? ""}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.infoCyan,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Passe o celular apenas para quem vai fazer a mímica e escolha a dificuldade:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: RiskLevel.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final risk = RiskLevel.values[index];
                    return _RiskOptionButton(
                      riskLevel: risk,
                      onTap: () {
                        ref
                            .read(gameNotifierProvider.notifier)
                            .selectRiskAndStartPreparation(risk);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskOptionButton extends StatelessWidget {
  final RiskLevel riskLevel;
  final VoidCallback onTap;

  const _RiskOptionButton({
    required this.riskLevel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = _colorForRisk(riskLevel);

    return Material(
      color: AppTheme.surfaceCard,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '+${riskLevel.pointsOnSuccess}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          riskLevel.label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                          ),
                        ),
                        if (riskLevel == RiskLevel.bonus) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.dangerRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'ERROU: -2 PTS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      riskLevel.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: accentColor, size: 32),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorForRisk(RiskLevel risk) {
    return switch (risk) {
      RiskLevel.easy => AppTheme.successGreen,
      RiskLevel.normal => AppTheme.infoCyan,
      RiskLevel.hard => AppTheme.accentAmber,
      RiskLevel.bonus => AppTheme.dangerRed,
    };
  }
}

