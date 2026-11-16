import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/nem_a_pato_enums.dart';

/// Grade compacta 2x2 de Votacao de Punicao para o rodape da tela de turno.
/// Exibe as 4 opcoes oficiais (So o pior bebe, 1/3 bebe, Metade bebe, So o melhor nao bebe).
class PunishmentVoteSelector extends StatelessWidget {
  final PunishmentType? selectedPunishment;
  final ValueChanged<PunishmentType> onSelect;

  const PunishmentVoteSelector({
    super.key,
    required this.selectedPunishment,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'VOTE NA PUNIÇÃO DA RODADA:',
          textAlign: TextAlign.center,
          style: AppTheme.displayFont(
            fontSize: 14,
            color: AppTheme.accentYellow,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.9,
          children: PunishmentType.values.map((punishment) {
            final isSelected = punishment == selectedPunishment;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onSelect(punishment);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryViolet
                      : AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        isSelected ? AppTheme.accentYellow : Colors.white12,
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppTheme.primaryVioletShadow
                          : const Color(0xFF160B36),
                      offset: const Offset(0, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.sports_bar_rounded,
                      size: 18,
                      color: isSelected
                          ? AppTheme.accentYellow
                          : Colors.white60,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        punishment.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyFont(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(growable: false),
        ),
      ],
    );
  }
}

