import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/nem_a_pato_enums.dart';
import '../state/nem_a_pato_notifier.dart';
import 'nem_a_pato_classic_page.dart';
import 'nem_a_pato_eighty_percent_alert_page.dart';
import 'nem_a_pato_home_page.dart';
import 'nem_a_pato_pass_device_page.dart';
import 'nem_a_pato_round_result_page.dart';
import 'nem_a_pato_secret_turn_page.dart';
import 'nem_a_pato_setup_page.dart';

/// Roteador reativo das telas do jogo "Nem a Pato" com base em [NemAPatoPhase].
class NemAPatoFlowShellPage extends ConsumerWidget {
  const NemAPatoFlowShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.phase),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      child: switch (phase) {
        NemAPatoPhase.home =>
          const NemAPatoHomePage(key: ValueKey('nap_home')),
        NemAPatoPhase.setup =>
          const NemAPatoSetupPage(key: ValueKey('nap_setup')),
        NemAPatoPhase.classicQuestion || NemAPatoPhase.classicReveal =>
          const NemAPatoClassicPage(key: ValueKey('nap_classic')),
        NemAPatoPhase.secretPassDevice =>
          const NemAPatoPassDevicePage(key: ValueKey('nap_pass_device')),
        NemAPatoPhase.secretPlayerTurn =>
          const NemAPatoSecretTurnPage(key: ValueKey('nap_secret_turn')),
        NemAPatoPhase.secretEightyPercentAlert =>
          const NemAPatoEightyPercentAlertPage(key: ValueKey('nap_80_alert')),
        NemAPatoPhase.secretRoundResult =>
          const NemAPatoRoundResultPage(key: ValueKey('nap_result')),
      },
    );
  }
}

