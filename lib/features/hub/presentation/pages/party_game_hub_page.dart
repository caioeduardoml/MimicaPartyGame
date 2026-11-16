import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/game_button.dart';
import '../../../mimica/presentation/pages/game_flow_shell_page.dart';
import '../../../nem_a_pato/presentation/pages/nem_a_pato_flow_shell_page.dart';
import '../state/hub_navigation_notifier.dart';

/// Roteador principal do Party Game Hub.
/// Exibe o menu de selecao de jogos ou o jogo escolhido pelo usuario.
class PartyGameHubPage extends ConsumerWidget {
  const PartyGameHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGame = ref.watch(hubSelectedGameProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (selectedGame) {
        HubSelectedGame.none =>
          const _HubSelectionMenuView(key: ValueKey('hub_menu')),
        HubSelectedGame.mimicaParty =>
          const GameFlowShellPage(key: ValueKey('hub_mimica')),
        HubSelectedGame.nemAPato =>
          const NemAPatoFlowShellPage(key: ValueKey('hub_nem_a_pato')),
      },
    );
  }
}

class _HubSelectionMenuView extends ConsumerWidget {
  const _HubSelectionMenuView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                // Cabecalho do Party Game Hub
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, 5),
                      child: Text(
                        'PARTY GAME HUB',
                        textAlign: TextAlign.center,
                        style: AppTheme.displayFont(
                          fontSize: 38,
                          color: const Color(0xFF12082B),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Text(
                      'PARTY GAME HUB',
                      textAlign: TextAlign.center,
                      style: AppTheme.displayFont(
                        fontSize: 38,
                        color: AppTheme.accentYellow,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolha qual jogo a galera vai jogar na mesa agora:',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyFont(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 28),

                // Cartao Jogo 1: Mimica Party
                Expanded(
                  child: _HubGameCard(
                    title: 'MÍMICA PARTY',
                    badgeText: 'EQUIPES & TEMPO',
                    description:
                        '2 a 6 equipes, 4 níveis de risco (Fácil ao Bônus com penalidade física) e cronômetro de 70s!',
                    icon: Icons.theater_comedy_rounded,
                    cardColor: AppTheme.primaryViolet,
                    shadowColor: AppTheme.primaryVioletShadow,
                    buttonLabel: 'ABRIR MÍMICA PARTY',
                    buttonStyle: GameButtonStyle.yellow,
                    onTap: () {
                      ref
                          .read(hubSelectedGameProvider.notifier)
                          .openMimicaParty();
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Cartao Jogo 2: Nem a Pato
                Expanded(
                  child: _HubGameCard(
                    title: 'NEM A PATO!',
                    badgeText: 'CHUTES & PUNIÇÃO',
                    description:
                        'Estimativas numéricas absurdas! Modo Clássico na mesa ou Modo Secreto com trava psicológica dos 80%.',
                    icon: Icons.psychology_alt_rounded,
                    cardColor: const Color(0xFF0E7490),
                    shadowColor: const Color(0xFF083344),
                    buttonLabel: 'ABRIR NEM A PATO!',
                    buttonStyle: GameButtonStyle.yellow,
                    onTap: () {
                      ref.read(hubSelectedGameProvider.notifier).openNemAPato();
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HubGameCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final String description;
  final IconData icon;
  final Color cardColor;
  final Color shadowColor;
  final String buttonLabel;
  final GameButtonStyle buttonStyle;
  final VoidCallback onTap;

  const _HubGameCard({
    required this.title,
    required this.badgeText,
    required this.description,
    required this.icon,
    required this.cardColor,
    required this.shadowColor,
    required this.buttonLabel,
    required this.buttonStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 8),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            offset: const Offset(0, 12),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: AppTheme.accentYellow,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badgeText,
                        style: AppTheme.displayFont(
                          fontSize: 11,
                          color: AppTheme.accentYellow,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: AppTheme.displayFont(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            description,
            style: AppTheme.bodyFont(
              fontSize: 14.5,
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.35,
            ),
          ),
          const Spacer(),
          GameButton(
            label: buttonLabel,
            icon: Icons.play_circle_fill_rounded,
            buttonStyle: buttonStyle,
            height: 54,
            fontSize: 17,
            depth: 5,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

