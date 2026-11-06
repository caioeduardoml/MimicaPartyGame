import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/game_enums.dart';
import '../../domain/entities/team_entity.dart';
import '../state/game_notifier.dart';

/// Tela 2: Setup - Configuracao da Partida:
/// - Slider de Pontos (20 a 60)
/// - Selecao de Categorias Ativas (minimo 4)
/// - Gerenciamento de Equipes (2 a 6 equipes, 2 a 6 jogadores cada)
class SetupPage extends ConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorMessage = ref.watch(
      gameNotifierProvider.select((s) => s.errorMessage),
    );
    final canStart = ref.watch(
      gameNotifierProvider.select((s) => s.canStartMatch),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('CONFIGURAR PARTIDA'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).returnToHome();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (errorMessage != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.dangerRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.dangerRed),
                ),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TargetScoreSection(),
                    SizedBox(height: 20),
                    _TeamsManagementSection(),
                    SizedBox(height: 20),
                    _CategoriesSelectionSection(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ElevatedButton.icon(
                onPressed: canStart
                    ? () {
                        ref.read(gameNotifierProvider.notifier).startMatch();
                      }
                    : null,
                icon: const Icon(Icons.sports_esports_rounded),
                label: const Text('COMEÇAR PARTIDA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetScoreSection extends ConsumerWidget {
  const _TargetScoreSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetScore = ref.watch(
      gameNotifierProvider.select((s) => s.targetScore),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pontuação para Vencer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentAmber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$targetScore pts',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: targetScore.toDouble(),
              min: 20,
              max: 60,
              divisions: 8,
              activeColor: AppTheme.accentAmber,
              label: '$targetScore pontos',
              onChanged: (val) {
                ref
                    .read(gameNotifierProvider.notifier)
                    .setTargetScore(val.round());
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('20 pts (Rápido)', style: TextStyle(color: Colors.white54, fontSize: 12)),
                Text('60 pts (Longo)', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamsManagementSection extends ConsumerWidget {
  const _TeamsManagementSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(gameNotifierProvider.select((s) => s.teams));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Equipes (${teams.length}/6)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (teams.length < 6)
                  TextButton.icon(
                    onPressed: () => _showAddTeamDialog(context, ref),
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        color: AppTheme.infoCyan),
                    label: const Text(
                      'Adicionar',
                      style: TextStyle(color: AppTheme.infoCyan),
                    ),
                  ),
              ],
            ),
            const Text(
              'Mínimo de 2 e máximo de 6 equipes (2 a 6 jogadores por equipe).',
              style: TextStyle(fontSize: 13, color: Colors.white60),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teams.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _TeamConfigTile(
                  team: teams[index],
                  canDelete: teams.length > 2,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTeamDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    int players = 2;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceCard,
              title: const Text('Nova Equipe'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      labelText: 'Nome da Equipe',
                      hintText: 'Ex: Os Vingadores',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jogadores (2 a 6):'),
                      Row(
                        children: [
                          IconButton(
                            onPressed: players > 2
                                ? () => setModalState(() => players--)
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '$players',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: players < 6
                                ? () => setModalState(() => players++)
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(110, 44),
                  ),
                  onPressed: () {
                    ref.read(gameNotifierProvider.notifier).addTeam(
                          name: controller.text,
                          playersCount: players,
                        );
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _TeamConfigTile extends ConsumerWidget {
  final TeamEntity team;
  final bool canDelete;

  const _TeamConfigTile({
    required this.team,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.groups_rounded, color: AppTheme.accentAmber),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _showEditNameDialog(context, ref),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          team.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.edit_rounded,
                        size: 15,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                  Text(
                    '${team.playersCount} jogadores',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: team.playersCount > 2
                ? () {
                    ref.read(gameNotifierProvider.notifier).updateTeam(
                          teamId: team.id,
                          playersCount: team.playersCount - 1,
                        );
                  }
                : null,
            icon: const Icon(Icons.remove_circle_outline, size: 20),
          ),
          Text(
            '${team.playersCount}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: team.playersCount < 6
                ? () {
                    ref.read(gameNotifierProvider.notifier).updateTeam(
                          teamId: team.id,
                          playersCount: team.playersCount + 1,
                        );
                  }
                : null,
            icon: const Icon(Icons.add_circle_outline, size: 20),
          ),
          if (canDelete)
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                ref.read(gameNotifierProvider.notifier).removeTeam(team.id);
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

  void _showEditNameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: team.name);
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          title: const Text('Renomear Equipe'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 20,
            decoration: const InputDecoration(
              labelText: 'Nome da Equipe',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 44),
              ),
              onPressed: () {
                ref.read(gameNotifierProvider.notifier).updateTeam(
                      teamId: team.id,
                      name: controller.text,
                    );
                Navigator.of(ctx).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}

class _CategoriesSelectionSection extends ConsumerWidget {
  const _CategoriesSelectionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCategories = ref.watch(
      gameNotifierProvider.select((s) => s.activeCategories),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categorias Ativas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${activeCategories.length}/${GameCategory.values.length}',
                  style: const TextStyle(
                    color: AppTheme.infoCyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Selecione ao menos 4 categorias para os sorteios de cada turno.',
              style: TextStyle(fontSize: 13, color: Colors.white60),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GameCategory.values.map((category) {
                final isSelected = activeCategories.contains(category);
                return FilterChip(
                  selected: isSelected,
                  label: Text(category.label),
                  selectedColor: AppTheme.primaryPurple,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) {
                    ref
                        .read(gameNotifierProvider.notifier)
                        .toggleCategory(category);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

