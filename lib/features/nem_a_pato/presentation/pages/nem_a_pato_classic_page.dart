import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/game_button.dart';
import '../../domain/entities/nem_a_pato_enums.dart';
import '../state/nem_a_pato_notifier.dart';

/// Tela 3A do "Nem a Pato": Modo Classico (Aberto / Rapido).
/// - Exibe o Tema, a Pergunta em destaque e a Punicao sugerida da rodada.
/// - Botao gigante "REVELAR RESPOSTA", que mostra o gabarito + curiosidade e
///   permite sortear a proxima pergunta imediatamente.
class NemAPatoClassicPage extends ConsumerWidget {
  const NemAPatoClassicPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.phase),
    );
    final question = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.currentQuestion),
    );
    final activePunishment = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.activePunishment),
    );

    if (question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isRevealed = phase == NemAPatoPhase.classicReveal;

    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('MODO CLÁSSICO'),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, size: 28),
            onPressed: () {
              ref.read(nemAPatoNotifierProvider.notifier).returnToHome();
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Badge de Tema + Punicao sugerida (Wrap evita RenderFlex overflow em telas menores)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.infoCyan,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        question.theme.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.displayFont(
                          fontSize: 12.5,
                          color: const Color(0xFF12082B),
                        ),
                      ),
                    ),
                    if (activePunishment != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.dangerRed,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'PUNIÇÃO: ${activePunishment.shortLabel.toUpperCase()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.displayFont(
                            fontSize: 12.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Cartao Gigante da Pergunta
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.help_rounded,
                          size: 46,
                          color: AppTheme.accentYellow,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          question.questionText,
                          textAlign: TextAlign.center,
                          style: AppTheme.displayFont(
                            fontSize: 25,
                            color: Colors.white,
                            height: 1.25,
                          ),
                        ),
                        if (isRevealed) ...[
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
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
                                    fontSize: 13,
                                    color: Colors.black87,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  question.formattedAnswer,
                                  textAlign: TextAlign.center,
                                  style: AppTheme.displayFont(
                                    fontSize: 32,
                                    color: Colors.white,
                                  ),
                                ),
                                if (question.curiosityNote != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    question.curiosityNote!,
                                    textAlign: TextAlign.center,
                                    style: AppTheme.bodyFont(
                                      fontSize: 13.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 24),
                          Text(
                            'Chutem em voz alta na mesa! Se duvidar do chute anterior, grite "NEM A PATO!"',
                            textAlign: TextAlign.center,
                            style: AppTheme.bodyFont(
                              fontSize: 14,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botao Gigante de Revelar ou Proxima Pergunta
                if (!isRevealed)
                  GameButton(
                    label: 'REVELAR RESPOSTA',
                    icon: Icons.visibility_rounded,
                    buttonStyle: GameButtonStyle.yellow,
                    height: 68,
                    fontSize: 22,
                    depth: 8,
                    onPressed: () {
                      ref
                          .read(nemAPatoNotifierProvider.notifier)
                          .revealClassicAnswer();
                    },
                  )
                else
                  GameButton(
                    label: 'PRÓXIMA PERGUNTA',
                    icon: Icons.navigate_next_rounded,
                    buttonStyle: GameButtonStyle.primary,
                    height: 68,
                    fontSize: 22,
                    depth: 8,
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

