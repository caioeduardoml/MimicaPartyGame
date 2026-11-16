import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Jogos disponiveis dentro do Party Game Hub.
enum HubSelectedGame {
  none,
  mimicaParty,
  nemAPato,
}

/// Provider global que controla qual jogo esta aberto no momento (ou se esta no Menu do Hub).
final hubSelectedGameProvider =
    NotifierProvider<HubNavigationNotifier, HubSelectedGame>(
  HubNavigationNotifier.new,
);

class HubNavigationNotifier extends Notifier<HubSelectedGame> {
  @override
  HubSelectedGame build() => HubSelectedGame.none;

  void openMimicaParty() => state = HubSelectedGame.mimicaParty;

  void openNemAPato() => state = HubSelectedGame.nemAPato;

  void returnToHubMenu() => state = HubSelectedGame.none;
}

