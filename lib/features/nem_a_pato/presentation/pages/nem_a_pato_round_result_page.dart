import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/game_button.dart';
import '../../domain/entities/player_round_result_entity.dart';
import '../state/nem_a_pato_notifier.dart';

/// Tela 5 do "Nem a Pato": Resultado do Modo Secreto.
/// - Exibe a Resposta Correta em destaque.
/// - Mostra a Punicao Vencedora da rodada.
/// - Lista o Ranking completo de jogadores (do menor erro absoluto para o maior)
///   destacando em verde o vencedor e em vermelho todos os jogadores que sofrem a punicao.
class NemAPatoRoundResultPage extends ConsumerWidget {
  const NemAPatoRoundResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.currentQuestion),
    );
    final activePunishment = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.activePunishment),
    );
    final ranking = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.roundRanking),
    );

    if (question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('RESULTADO DA RODADA'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              tooltip: 'Voltar ao Início',
              icon: const Icon(Icons.close_rounded, size: 28),
              onPressed: () {
                ref.read(nemAPatoNotifierProvider.notifier).returnToHome();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Destaque da Resposta Correta
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: AppTheme.successGreenShadow,
                        offset: Offset(0, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'RESPOSTA EXATA:',
                        style: AppTheme.displayFont(
                          fontSize: 12,
                          color: Colors.black87,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        question.formattedAnswer,
                        textAlign: TextAlign.center,
                        style: AppTheme.displayFont(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      if (question.curiosityNote != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          question.curiosityNote!,
                          textAlign: TextAlign.center,
                          style: AppTheme.bodyFont(
                            fontSize: 12.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Banner da Punicao Aplicada
                if (activePunishment != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.dangerRed,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.dangerRedShadow,
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sports_bar_rounded,
                          color: AppTheme.accentYellow,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'PUNIÇÃO: ${activePunishment.label.toUpperCase()}',
                            textAlign: TextAlign.center,
                            style: AppTheme.displayFont(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),

                Text(
                  'RANKING DE PROXIMIDADE (QUEM BEBE?):',
                  style: AppTheme.displayFont(
                    fontSize: 15,
                    color: AppTheme.accentYellow,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),

                // 3. Lista Ordenada de Jogadores
                Expanded(
                  child: ListView.separated(
                    itemCount: ranking.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _PlayerRankingCard(result: ranking[index]);
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // 4. Botao Proxima Rodada
                GameButton(
                  label: 'PRÓXIMA PERGUNTA',
                  icon: Icons.replay_rounded,
                  buttonStyle: GameButtonStyle.yellow,
                  height: 62,
                  fontSize: 20,
                  depth: 7,
                  onPressed: () {
                    ref
                        .read(nemAPatoNotifierProvider.notifier)
                        .startNextRound();
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

class _PlayerRankingCard extends StatelessWidget {
  final PlayerRoundResultEntity result;

  const _PlayerRankingCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final badgeColor = result.isWinner
        ? AppTheme.successGreen
        : result.isPunished
            ? AppTheme.dangerRed
            : AppTheme.infoCyan;

    final statusText = result.isWinner
        ? 'CRAVOU / VENCEDOR!'
        : result.isPunished
            ? 'BEBE / PUNIDO!'
            : 'ESCAPOU';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: result.isPunished
            ? const Color(0xFF3B1229)
            : AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: badgeColor,
          width: result.isWinner || result.isPunished ? 2.5 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: badgeColor,
            child: Text(
              '#${result.rankPosition}',
              style: AppTheme.displayFont(
                fontSize: 15,
                color: result.isWinner ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.player.name,
                  style: AppTheme.displayFont(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Chutou: ${NemAPatoNotifier.formatLargeNumber(result.guessValue)} '
                  '(Erro: ${NemAPatoNotifier.formatLargeNumber(result.absoluteDifference)})',
                  style: AppTheme.bodyFont(
                    fontSize: 12.5,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: AppTheme.displayFont(
                fontSize: 11.5,
                color: result.isWinner ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

