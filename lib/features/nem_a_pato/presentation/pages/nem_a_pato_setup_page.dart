import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/game_button.dart';
import '../../domain/entities/nem_a_pato_enums.dart';
import '../../domain/entities/nem_a_pato_player_entity.dart';
import '../state/nem_a_pato_notifier.dart';

/// Tela 2 do "Nem a Pato": Setup - Configura:
/// - Toggle: Modo Classico vs Modo Secreto (Pass-and-Play)
/// - Toggle Punicao (Apenas Modo Secreto): Votacao vs Aleatoria
/// - Lista de Jogadores (2 a 15, sugerindo ate 8 no Modo Secreto)
class NemAPatoSetupPage extends ConsumerWidget {
  const NemAPatoSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameMode = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.gameMode),
    );
    final errorMessage = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.errorMessage),
    );
    final canStart = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.canStartGame),
    );

    return PartyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('CONFIGURAR PARTIDA'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              ref.read(nemAPatoNotifierProvider.notifier).returnToHome();
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (errorMessage != null)
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerRed,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyFont(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _GameModeToggleSection(),
                      const SizedBox(height: 16),
                      if (gameMode == NemAPatoGameMode.secret) ...[
                        const _PunishmentModeToggleSection(),
                        const SizedBox(height: 16),
                      ],
                      const _PlayersSetupSection(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GameButton(
                  label: 'INICIAR PARTIDA',
                  icon: Icons.rocket_launch_rounded,
                  buttonStyle: GameButtonStyle.success,
                  height: 64,
                  fontSize: 22,
                  onPressed: canStart
                      ? () {
                          ref
                              .read(nemAPatoNotifierProvider.notifier)
                              .startGame();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameModeToggleSection extends ConsumerWidget {
  const _GameModeToggleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.gameMode),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF160B36),
            offset: Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MODO DE JOGO',
            style: AppTheme.displayFont(
              fontSize: 18,
              color: AppTheme.accentYellow,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: NemAPatoGameMode.values.map((mode) {
              final isSelected = mode == selectedMode;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: mode == NemAPatoGameMode.classic ? 6 : 0,
                    left: mode == NemAPatoGameMode.secret ? 6 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(nemAPatoNotifierProvider.notifier)
                          .setGameMode(mode);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryViolet
                            : AppTheme.surfaceCardLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.accentYellow
                              : Colors.white12,
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            mode == NemAPatoGameMode.classic
                                ? Icons.record_voice_over_rounded
                                : Icons.lock_person_rounded,
                            color: isSelected
                                ? AppTheme.accentYellow
                                : Colors.white70,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mode.label,
                            textAlign: TextAlign.center,
                            style: AppTheme.displayFont(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mode.subtitle,
                            textAlign: TextAlign.center,
                            style: AppTheme.bodyFont(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _PunishmentModeToggleSection extends ConsumerWidget {
  const _PunishmentModeToggleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final punishmentMode = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.punishmentMode),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF160B36),
            offset: Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DEFINIÇÃO DA PUNIÇÃO',
            style: AppTheme.displayFont(
              fontSize: 18,
              color: AppTheme.infoCyan,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: PunishmentSelectionMode.values.map((mode) {
              final isSelected = mode == punishmentMode;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: mode == PunishmentSelectionMode.voting ? 6 : 0,
                    left: mode == PunishmentSelectionMode.random ? 6 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(nemAPatoNotifierProvider.notifier)
                          .setPunishmentSelectionMode(mode);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.infoCyan
                            : AppTheme.surfaceCardLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            mode == PunishmentSelectionMode.voting
                                ? Icons.how_to_vote_rounded
                                : Icons.casino_rounded,
                            size: 20,
                            color: isSelected
                                ? const Color(0xFF12082B)
                                : Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              mode.label,
                              style: AppTheme.displayFont(
                                fontSize: 14,
                                color: isSelected
                                    ? const Color(0xFF12082B)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _PlayersSetupSection extends ConsumerWidget {
  const _PlayersSetupSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.players),
    );
    final gameMode = ref.watch(
      nemAPatoNotifierProvider.select((s) => s.gameMode),
    );

    final isSecret = gameMode == NemAPatoGameMode.secret;
    final exceedsSecretRecommendation = isSecret && players.length > 8;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF160B36),
            offset: Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JOGADORES (${players.length}/15)',
                    style: AppTheme.displayFont(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isSecret
                        ? 'Sugerido máx. 8 jogadores no Modo Secreto'
                        : 'Opcional no Modo Clássico (2 a 15 na mesa)',
                    style: AppTheme.bodyFont(
                      fontSize: 12,
                      color: exceedsSecretRecommendation
                          ? AppTheme.warningOrange
                          : Colors.white60,
                    ),
                  ),
                ],
              ),
              if (players.length < 15)
                GameIconButton3D(
                  icon: Icons.person_add_alt_1_rounded,
                  buttonStyle: GameButtonStyle.yellow,
                  onPressed: () => _showAddPlayerDialog(context, ref),
                ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: players.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final player = players[index];
              return _PlayerTile(
                index: index + 1,
                player: player,
                canDelete: players.length > 2,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Novo Jogador',
            style: AppTheme.displayFont(fontSize: 22),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 18,
            decoration: const InputDecoration(
              labelText: 'Nome do Jogador',
              hintText: 'Ex: Caio',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            SizedBox(
              width: 120,
              child: GameButton(
                label: 'ADICIONAR',
                buttonStyle: GameButtonStyle.yellow,
                height: 44,
                fontSize: 15,
                depth: 4,
                onPressed: () {
                  ref
                      .read(nemAPatoNotifierProvider.notifier)
                      .addPlayer(controller.text);
                  Navigator.of(ctx).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlayerTile extends ConsumerWidget {
  final int index;
  final NemAPatoPlayerEntity player;
  final bool canDelete;

  const _PlayerTile({
    required this.index,
    required this.player,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.accentYellow,
            child: Text(
              '$index',
              style: AppTheme.displayFont(
                fontSize: 15,
                color: const Color(0xFF1F1235),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _showRenameDialog(context, ref),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      player.name,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.displayFont(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
          ),
          if (canDelete)
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                ref
                    .read(nemAPatoNotifierProvider.notifier)
                    .removePlayer(player.id);
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppTheme.dangerRed,
              ),
            ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: player.name);
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          title: Text(
            'Editar Nome',
            style: AppTheme.displayFont(fontSize: 20),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 18,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            SizedBox(
              width: 110,
              child: GameButton(
                label: 'SALVAR',
                buttonStyle: GameButtonStyle.yellow,
                height: 44,
                fontSize: 15,
                depth: 4,
                onPressed: () {
                  ref.read(nemAPatoNotifierProvider.notifier).updatePlayerName(
                        playerId: player.id,
                        newName: controller.text,
                      );
                  Navigator.of(ctx).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

