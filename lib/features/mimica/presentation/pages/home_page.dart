import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../state/game_notifier.dart';
import '../widgets/game_button.dart';

/// Tela 1: Home - Exibe o logotipo estilizado com contorno 3D e sombra obliqua,
/// botao "Jogar Agora" com animacao de pulso continuo e modal de Regras.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const _PartyLogoHeader(),
                const Spacer(),
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: GameButton(
                    label: 'JOGAR AGORA',
                    icon: Icons.play_arrow_rounded,
                    buttonStyle: GameButtonStyle.yellow,
                    height: 68,
                    fontSize: 24,
                    depth: 8,
                    onPressed: () {
                      ref.read(gameNotifierProvider.notifier).goToSetup();
                    },
                  ),
                ),
                const SizedBox(height: 18),
                GameButton(
                  label: 'COMO JOGAR / REGRAS',
                  icon: Icons.menu_book_rounded,
                  buttonStyle: GameButtonStyle.primary,
                  height: 58,
                  fontSize: 18,
                  onPressed: () => _showRulesDialog(context),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return const _RulesBottomSheetContent();
      },
    );
  }
}

class _PartyLogoHeader extends StatelessWidget {
  const _PartyLogoHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Emblema 3D Ludico
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: AppTheme.accentYellow,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: AppTheme.accentYellowShadow,
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
              Icons.theater_comedy_rounded,
              size: 76,
              color: Color(0xFF251351),
            ),
          ),
        ),
        const SizedBox(height: 28),
        // Titulo "MIMICA" com Stroke (Contorno) e Sombra Obliqua 3D
        Stack(
          alignment: Alignment.center,
          children: [
            // Camada de Sombra Obliqua Profunda
            Transform.translate(
              offset: const Offset(0, 6),
              child: Text(
                'MÍMICA',
                textAlign: TextAlign.center,
                style: AppTheme.displayFont(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: const Color(0xFF14082E),
                ),
              ),
            ),
            // Camada de Contorno (Stroke)
            Text(
              'MÍMICA',
              textAlign: TextAlign.center,
              style: AppTheme.displayFont(
                fontSize: 60,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ).copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 8
                  ..color = AppTheme.primaryVioletShadow,
              ),
            ),
            // Camada Principal Branca/Amarela
            Text(
              'MÍMICA',
              textAlign: TextAlign.center,
              style: AppTheme.displayFont(
                fontSize: 60,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryViolet,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.primaryVioletShadow,
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            'PARTY GAME',
            textAlign: TextAlign.center,
            style: AppTheme.displayFont(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 5,
              color: AppTheme.accentYellow,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Reúna a galera, escolha o risco e faça a mímica antes do tempo acabar!',
          textAlign: TextAlign.center,
          style: AppTheme.bodyFont(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _RulesBottomSheetContent extends StatelessWidget {
  const _RulesBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppTheme.accentYellow,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'REGRAS DO JOGO',
                style: AppTheme.displayFont(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _RuleItem(
            title: '1. Equipes e Sorteio',
            description:
                'De 2 a 6 equipes (2 a 6 jogadores cada). No seu turno, o jogo sorteia 4 categorias e a equipe escolhe 1.',
          ),
          const _RuleItem(
            title: '2. Níveis de Risco',
            description:
                '• Fácil (+1 pt): 1 palavra simples.\n'
                '• Normal (+2 pts): 1 palavra específica.\n'
                '• Difícil (+3 pts): 2 palavras fáceis combinadas.\n'
                '• Bônus (+4 pts): 1 palavra normal + penalidade física. Se errar o Bônus, perde 2 pontos!',
          ),
          const _RuleItem(
            title: '3. Vitória Imediata',
            description:
                'São 5s de preparação e 70s de mímica. A primeira equipe que atingir a meta de pontos vence na hora!',
          ),
          const SizedBox(height: 18),
          GameButton(
            label: 'ENTENDI!',
            buttonStyle: GameButtonStyle.yellow,
            height: 54,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final String title;
  final String description;

  const _RuleItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                fontSize: 17,
                color: AppTheme.accentYellow,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTheme.bodyFont(
                fontSize: 14,
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
