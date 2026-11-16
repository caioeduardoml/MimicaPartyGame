import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/game_button.dart';
import '../state/nem_a_pato_notifier.dart';

/// Tela 4 (Condicional): Alerta Vermelho de Impacto Total da Regra dos 80%!
/// Acionada quando o maior palpite da mesa inteira ficou abaixo de 80% da resposta real.
/// Mantem os votos de punicao e reinicia o turno para todos chutarem mais alto.
class NemAPatoEightyPercentAlertPage extends ConsumerStatefulWidget {
  const NemAPatoEightyPercentAlertPage({super.key});

  @override
  ConsumerState<NemAPatoEightyPercentAlertPage> createState() =>
      _NemAPatoEightyPercentAlertPageState();
}

class _NemAPatoEightyPercentAlertPageState
    extends ConsumerState<NemAPatoEightyPercentAlertPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
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
    return Scaffold(
      backgroundColor: const Color(0xFF450A0A),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF991B1B),
              Color(0xFF450A0A),
              Color(0xFF280505),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 118,
                    height: 118,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentYellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentYellowShadow,
                          offset: Offset(0, 6),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      size: 72,
                      color: Color(0xFF7F1D1D),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'ALARME DOS 80%!',
                  textAlign: TextAlign.center,
                  style: AppTheme.displayFont(
                    fontSize: 40,
                    color: AppTheme.accentYellow,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'TODO MUNDO CHUTOU BAIXO DEMAIS!',
                  textAlign: TextAlign.center,
                  style: AppTheme.displayFont(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.accentYellow,
                      width: 2.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Nenhum palpite da mesa chegou a pelo menos 80% do valor verdadeiro!',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyFont(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Teremos uma RODADA EXTRA para a mesma pergunta! Os votos de punição foram mantidos, mas todos terão que dar um novo chute mais alto agora!',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyFont(
                          fontSize: 14.5,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GameButton(
                  label: 'INICIAR RODADA EXTRA!',
                  icon: Icons.local_fire_department_rounded,
                  buttonStyle: GameButtonStyle.yellow,
                  height: 68,
                  fontSize: 21,
                  depth: 8,
                  onPressed: () {
                    ref
                        .read(nemAPatoNotifierProvider.notifier)
                        .startExtraRoundAfterEightyPercentAlert();
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
