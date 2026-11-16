import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/game_button.dart';
import '../../domain/entities/nem_a_pato_enums.dart';
import '../state/nem_a_pato_notifier.dart';
import '../widgets/custom_magnitude_number_input.dart';
import '../widgets/punishment_vote_selector.dart';

/// Tela 3C (Turno Secreto do Jogador):
/// - Pergunta no topo
/// - Input Numerico Customizado no centro (Visor + Chips de Grandeza + Teclado 3D)
/// - Votacao de Punicao no rodape (quando aplicavel)
/// - Botao "CONFIRMAR CHUTE"
class NemAPatoSecretTurnPage extends ConsumerStatefulWidget {
  const NemAPatoSecretTurnPage({super.key});

  @override
  ConsumerState<NemAPatoSecretTurnPage> createState() =>
      _NemAPatoSecretTurnPageState();
}

class _NemAPatoSecretTurnPageState
    extends ConsumerState<NemAPatoSecretTurnPage> {
  String _rawDigits = '';
  NumberMagnitude _selectedMagnitude = NumberMagnitude.unit;
  PunishmentType? _selectedPunishment;

  @override
  Widget build(BuildContext context) {
    final currentPlayer = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.currentPlayer),
    );
    final question = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.currentQuestion),
    );
    final punishmentMode = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.punishmentMode),
    );
    final isExtraRound = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.hasTriggeredExtraRound),
    );
    final firstRoundGuesses = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.firstRoundGuesses),
    );
    final errorMessage = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.errorMessage),
    );

    if (question == null || currentPlayer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final previousGuess =
        isExtraRound ? firstRoundGuesses[currentPlayer.id] : null;
    final showPunishmentVoting =
        punishmentMode == PunishmentSelectionMode.voting && !isExtraRound;

    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('VEZ DE ${currentPlayer.name.toUpperCase()}'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.dangerRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyFont(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                // 1. Cartao da Pergunta no Topo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF150A33),
                        offset: Offset(0, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        question.theme.toUpperCase(),
                        style: AppTheme.displayFont(
                          fontSize: 12,
                          color: AppTheme.infoCyan,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        question.questionText,
                        textAlign: TextAlign.center,
                        style: AppTheme.displayFont(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                      if (previousGuess != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.warningOrange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.warningOrange,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.history_rounded,
                                color: AppTheme.accentYellow,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Seu 1º chute foi: ${NemAPatoNotifier.formatLargeNumber(previousGuess)} (Chute mais alto!)',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.bodyFont(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.accentYellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Input Numerico Customizado no Centro
                CustomMagnitudeNumberInput(
                  rawDigits: _rawDigits,
                  selectedMagnitude: _selectedMagnitude,
                  onDigitsChanged: (val) => setState(() => _rawDigits = val),
                  onMagnitudeChanged: (mag) =>
                      setState(() => _selectedMagnitude = mag),
                ),

                // 3. Votacao de Punicao no Rodape (Apenas 1º turno no modo Votacao)
                if (showPunishmentVoting) ...[
                  const SizedBox(height: 10),
                  PunishmentVoteSelector(
                    selectedPunishment: _selectedPunishment,
                    onSelect: (punishment) =>
                        setState(() => _selectedPunishment = punishment),
                  ),
                ],

                const SizedBox(height: 14),

                // 4. Botao Confirmar Chute
                GameButton(
                  label: 'CONFIRMAR CHUTE SECRETO',
                  icon: Icons.check_circle_rounded,
                  buttonStyle: GameButtonStyle.success,
                  height: 62,
                  fontSize: 19,
                  onPressed: () {
                    ref.read(nemAPatoNotifierProvider.notifier).submitSecretTurn(
                          rawNumberInput: _rawDigits,
                          magnitude: _selectedMagnitude,
                          votedPunishment: _selectedPunishment,
                        );
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

