import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/game_button.dart';
import '../../../hub/presentation/state/hub_navigation_notifier.dart';
import '../state/nem_a_pato_notifier.dart';

/// Tela 1 do "Nem a Pato": Home - Exibe o logotipo estilizado, botao "Novo Jogo",
/// "Como Jogar" e botao de retorno para o Menu do Hub.
class NemAPatoHomePage extends ConsumerWidget {
  const NemAPatoHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Voltar para o Hub de Jogos',
            icon: const Icon(Icons.grid_view_rounded, size: 28),
            onPressed: () {
              ref.read(hubSelectedGameProvider.notifier).returnToHubMenu();
            },
          ),
          title: const Text('PARTY GAME HUB'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const _NemAPatoLogoHeader(),
                const Spacer(),
                GameButton(
                  label: 'NOVO JOGO',
                  icon: Icons.play_arrow_rounded,
                  buttonStyle: GameButtonStyle.yellow,
                  height: 68,
                  fontSize: 24,
                  depth: 8,
                  onPressed: () {
                    ref.read(nemAPatoNotifierProvider.notifier).goToSetup();
                  },
                ),
                const SizedBox(height: 16),
                GameButton(
                  label: 'COMO JOGAR',
                  icon: Icons.help_outline_rounded,
                  buttonStyle: GameButtonStyle.cyan,
                  height: 58,
                  fontSize: 18,
                  onPressed: () => _showHowToPlaySheet(context),
                ),
                const SizedBox(height: 14),
                GameButton(
                  label: 'TROCAR DE JOGO (HUB)',
                  icon: Icons.swap_horiz_rounded,
                  buttonStyle: GameButtonStyle.neutral,
                  height: 52,
                  fontSize: 16,
                  onPressed: () {
                    ref
                        .read(hubSelectedGameProvider.notifier)
                        .returnToHubMenu();
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHowToPlaySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calculate_rounded,
                    color: AppTheme.accentYellow,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'COMO JOGAR NEM A PATO',
                    style: AppTheme.displayFont(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _RuleBlock(
                title: '1. Modo Clássico (Aberto na Mesa)',
                text:
                    'A pergunta aparece na tela grande. Os jogadores chutam em voz alta aumentando a aposta ou gritando "Nem a Pato!" se acharem que o anterior exagerou. Depois é só tocar em Revelar Resposta!',
              ),
              const _RuleBlock(
                title: '2. Modo Secreto (Pass-and-Play)',
                text:
                    'Cada jogador pega o celular na sua vez, digita seu chute secreto usando os botões de grandeza (Mil, Milhão, Bilhão...) e vota na punição da rodada.',
              ),
              const _RuleBlock(
                title: '3. A Regra Psicológica dos 80%',
                text:
                    'Se TODO MUNDO chutar muito baixo (abaixo de 80% da resposta real), o alarme vermelho toca! Ninguém vê a resposta e todos são obrigados a chutar mais alto numa Rodada Extra!',
              ),
              const SizedBox(height: 16),
              GameButton(
                label: 'BORA JOGAR!',
                buttonStyle: GameButtonStyle.yellow,
                height: 54,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NemAPatoLogoHeader extends StatelessWidget {
  const _NemAPatoLogoHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 124,
          height: 124,
          decoration: const BoxDecoration(
            color: AppTheme.infoCyan,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.infoCyanShadow,
                offset: Offset(0, 8),
                blurRadius: 0,
              ),
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 14),
                blurRadius: 16,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.psychology_alt_rounded,
              size: 76,
              color: Color(0xFF12082B),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 6),
              child: Text(
                'NEM A PATO!',
                textAlign: TextAlign.center,
                style: AppTheme.displayFont(
                  fontSize: 48,
                  color: const Color(0xFF12082B),
                  letterSpacing: 2,
                ),
              ),
            ),
            Text(
              'NEM A PATO!',
              textAlign: TextAlign.center,
              style: AppTheme.displayFont(
                fontSize: 48,
                letterSpacing: 2,
              ).copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 7
                  ..color = AppTheme.infoCyanShadow,
              ),
            ),
            Text(
              'NEM A PATO!',
              textAlign: TextAlign.center,
              style: AppTheme.displayFont(
                fontSize: 48,
                color: AppTheme.accentYellow,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.warningOrange,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.warningOrangeShadow,
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            'CHUTES ABSURDOS & PRESSÃO SOCIAL',
            style: AppTheme.displayFont(
              fontSize: 13,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Quem chegar mais perto do número real escapa. Quem chutar longe demais sofre a punição!',
          textAlign: TextAlign.center,
          style: AppTheme.bodyFont(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _RuleBlock extends StatelessWidget {
  final String title;
  final String text;

  const _RuleBlock({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCardLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.displayFont(
                fontSize: 16,
                color: AppTheme.accentYellow,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: AppTheme.bodyFont(
                fontSize: 13.5,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

