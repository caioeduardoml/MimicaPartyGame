import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/game_enums.dart';
import '../state/game_notifier.dart';

/// Tela 5: Selecao de Risco - Exibe os botoes Facil (1 pt), Normal (2 pts),
/// Dificil (3 pts) e Bonus (4 pts / -2 pts se errar).
/// Quando o turno atual da equipe e um Desafio Bonus Obrigatorio, bloqueia
/// Facil, Normal e Dificil, obrigando o jogador da vez a encarar o Bonus com punicao.
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
    final isMandatoryBonus = ref.watch(
      gameNotifierProvider.select((s) => s.isMandatoryBonusTurn),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isMandatoryBonus ? 'DESAFIO BÔNUS OBRIGATÓRIO' : 'NÍVEL DE RISCO',
        ),
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
                      'Equipe: ${currentTeam?.name ?? ""} • Jogador ${currentTeam?.currentPlayerNumber ?? 1} de ${currentTeam?.playersCount ?? 2}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
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
              const SizedBox(height: 14),
              if (isMandatoryBonus) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.dangerRed, width: 2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppTheme.accentYellow,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'RODADA DE BÔNUS OBRIGATÓRIO!',
                              textAlign: TextAlign.center,
                              style: AppTheme.displayFont(
                                fontSize: 17,
                                color: AppTheme.accentYellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Chegou a vez do Jogador ${currentTeam?.currentPlayerNumber ?? 1} encarar a mímica com punição física! Os níveis Fácil, Normal e Difícil estão bloqueados nesta rodada.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ] else ...[
                const Text(
                  'Passe o celular apenas para quem vai fazer a mímica e escolha a dificuldade:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: ListView.separated(
                  itemCount: RiskLevel.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final risk = RiskLevel.values[index];
                    final isLocked =
                        isMandatoryBonus && risk != RiskLevel.bonus;
                    return _RiskOptionButton(
                      riskLevel: risk,
                      isLocked: isLocked,
                      isHighlightedMandatory:
                          isMandatoryBonus && risk == RiskLevel.bonus,
                      onTap: isLocked
                          ? null
                          : () {
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
  final bool isLocked;
  final bool isHighlightedMandatory;
  final VoidCallback? onTap;

  const _RiskOptionButton({
    required this.riskLevel,
    required this.isLocked,
    required this.isHighlightedMandatory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = _colorForRisk(riskLevel);

    return Opacity(
      opacity: isLocked ? 0.35 : 1.0,
      child: Material(
        color: isHighlightedMandatory
            ? AppTheme.dangerRed.withValues(alpha: 0.18)
            : AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isLocked ? Colors.white24 : accentColor,
                width: isHighlightedMandatory ? 3 : 2,
              ),
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
                  child: isLocked
                      ? const Icon(
                          Icons.lock_rounded,
                          color: Colors.white54,
                          size: 28,
                        )
                      : Text(
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            riskLevel.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: isLocked ? Colors.white54 : accentColor,
                            ),
                          ),
                          if (riskLevel == RiskLevel.bonus)
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
                          if (isHighlightedMandatory)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentYellow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'OBRIGATÓRIO',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1F1235),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLocked
                            ? 'Bloqueado nesta rodada de Desafio Bônus Obrigatório'
                            : riskLevel.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isLocked ? Icons.lock_outline_rounded : Icons.chevron_right_rounded,
                  color: isLocked ? Colors.white38 : accentColor,
                  size: 32,
                ),
              ],
            ),
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
