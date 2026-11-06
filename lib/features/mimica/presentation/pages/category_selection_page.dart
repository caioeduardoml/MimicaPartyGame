import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/game_enums.dart';
import '../state/game_notifier.dart';

/// Tela 4: Selecao de Categoria - Exibe as 4 categorias sorteadas
/// para a equipe atual escolher UMA.
class CategorySelectionPage extends ConsumerWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawnCategories = ref.watch(
      gameNotifierProvider.select((s) => s.drawnCategories),
    );
    final currentTeam = ref.watch(
      gameNotifierProvider.select((s) => s.currentTeam),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ESCOLHA A CATEGORIA'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Vez de ${currentTeam?.name ?? "Equipe"}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentAmber,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Foram sorteadas 4 opções. Escolha 1 categoria para a mímica:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: drawnCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final category = drawnCategories[index];
                    return _CategoryOptionCard(
                      category: category,
                      onTap: () {
                        ref
                            .read(gameNotifierProvider.notifier)
                            .selectCategory(category);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryOptionCard extends StatelessWidget {
  final GameCategory category;
  final VoidCallback onTap;

  const _CategoryOptionCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceCard,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.primaryPurple.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _iconForCategory(category),
                size: 48,
                color: AppTheme.infoCyan,
              ),
              const SizedBox(height: 14),
              Text(
                category.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForCategory(GameCategory category) {
    return switch (category) {
      GameCategory.acoes => Icons.directions_run_rounded,
      GameCategory.objetos => Icons.chair_rounded,
      GameCategory.lugares => Icons.place_rounded,
      GameCategory.animais => Icons.pets_rounded,
      GameCategory.verbos => Icons.bolt_rounded,
      GameCategory.filmes => Icons.movie_creation_rounded,
      GameCategory.herois => Icons.shield_rounded,
      GameCategory.profissoes => Icons.work_rounded,
      GameCategory.esportes => Icons.sports_soccer_rounded,
      GameCategory.comidas => Icons.restaurant_rounded,
      GameCategory.cep => Icons.public_rounded,
      GameCategory.dificilAleatorio => Icons.shuffle_rounded,
    };
  }
}

