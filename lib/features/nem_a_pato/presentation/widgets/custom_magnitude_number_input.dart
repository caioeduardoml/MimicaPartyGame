import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/nem_a_pato_enums.dart';
import '../state/nem_a_pato_notifier.dart';

/// Componente visual de Input Numerico Customizado + Seletor de Grandeza (x1 a Trilhao).
///
/// Projetado especificamente para Party Games Pass-and-Play:
/// - Evita abrir o teclado nativo do Android (que cobre metade da tela).
/// - Possui visor de alto impacto mostrando o numero digitado e a traducao por extenso em tempo real.
/// - Possui chips 3D tateis para alternar entre Unidade, Mil, Milhao, Bilhao e Trilhao.
/// - Possui teclado numerico 3D proprio com suporte a virgula decimal e backspace.
class CustomMagnitudeNumberInput extends StatelessWidget {
  final String rawDigits;
  final NumberMagnitude selectedMagnitude;
  final ValueChanged<String> onDigitsChanged;
  final ValueChanged<NumberMagnitude> onMagnitudeChanged;

  const CustomMagnitudeNumberInput({
    super.key,
    required this.rawDigits,
    required this.selectedMagnitude,
    required this.onDigitsChanged,
    required this.onMagnitudeChanged,
  });

  void _onKeyTap(String key) {
    HapticFeedback.selectionClick();

    if (key == 'C') {
      onDigitsChanged('');
      return;
    }

    if (key == 'BACK') {
      if (rawDigits.isNotEmpty) {
        onDigitsChanged(rawDigits.substring(0, rawDigits.length - 1));
      }
      return;
    }

    if (key == ',') {
      if (rawDigits.contains(',')) return;
      final next = rawDigits.isEmpty ? '0,' : '$rawDigits,';
      onDigitsChanged(next);
      return;
    }

    // Limita a 9 caracteres para manter legibilidade e evitar overflow matematico
    if (rawDigits.length >= 9) return;

    // Limita a no maximo 2 casas decimais apos a virgula
    final commaIndex = rawDigits.indexOf(',');
    if (commaIndex != -1 && rawDigits.length - commaIndex > 2) {
      return;
    }

    // Evita zeros a esquerda desnecessarios (ex: "00")
    if (rawDigits == '0' && key != ',') {
      onDigitsChanged(key);
      return;
    }

    onDigitsChanged('$rawDigits$key');
  }

  @override
  Widget build(BuildContext context) {
    final calculatedValue = NemAPatoNotifier.parseAndCalculateGuess(
      rawInput: rawDigits,
      magnitude: selectedMagnitude,
    );

    final previewText = calculatedValue != null
        ? 'Valor final: ${NemAPatoNotifier.formatLargeNumber(calculatedValue)}'
        : 'Digite seu palpite abaixo';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Visor Digital 3D do Palpite
        _GuessDisplayMonitor(
          rawDigits: rawDigits,
          selectedMagnitude: selectedMagnitude,
          previewText: previewText,
          hasValidValue: calculatedValue != null,
        ),
        const SizedBox(height: 12),

        // 2. Barra de Chips 3D de Grandeza (Unidade, Mil, Milhao, Bilhao, Trilhao)
        _MagnitudeSelectorRow(
          selectedMagnitude: selectedMagnitude,
          onSelect: (mag) {
            HapticFeedback.lightImpact();
            onMagnitudeChanged(mag);
          },
        ),
        const SizedBox(height: 12),

        // 3. Teclado Numerico 3D Compacto
        _TactileNumericKeypad(onKeyTap: _onKeyTap),
      ],
    );
  }
}

class _GuessDisplayMonitor extends StatelessWidget {
  final String rawDigits;
  final NumberMagnitude selectedMagnitude;
  final String previewText;
  final bool hasValidValue;

  const _GuessDisplayMonitor({
    required this.rawDigits,
    required this.selectedMagnitude,
    required this.previewText,
    required this.hasValidValue,
  });

  @override
  Widget build(BuildContext context) {
    final displayDigits = rawDigits.isEmpty ? '0' : rawDigits;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF140A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasValidValue ? AppTheme.accentYellow : Colors.white24,
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  displayDigits,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.displayFont(
                    fontSize: 40,
                    color: hasValidValue ? Colors.white : Colors.white38,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              if (selectedMagnitude != NumberMagnitude.unit) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentYellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    selectedMagnitude.label.toUpperCase(),
                    style: AppTheme.displayFont(
                      fontSize: 15,
                      color: const Color(0xFF1F1235),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            previewText,
            textAlign: TextAlign.center,
            style: AppTheme.bodyFont(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: hasValidValue ? AppTheme.infoCyan : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class _MagnitudeSelectorRow extends StatelessWidget {
  final NumberMagnitude selectedMagnitude;
  final ValueChanged<NumberMagnitude> onSelect;

  const _MagnitudeSelectorRow({
    required this.selectedMagnitude,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: NumberMagnitude.values.map((mag) {
          final isSelected = mag == selectedMagnitude;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(mag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accentYellow
                      : AppTheme.surfaceCardLight,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppTheme.accentYellowShadow
                          : const Color(0xFF180C3A),
                      offset: Offset(0, isSelected ? 4 : 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  mag.shortChip,
                  style: AppTheme.displayFont(
                    fontSize: 14,
                    color: isSelected
                        ? const Color(0xFF1F1235)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _TactileNumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyTap;

  const _TactileNumericKeypad({required this.onKeyTap});

  static const List<List<String>> _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [',', '0', 'BACK'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _KeypadButton3D(
                    keyLabel: key,
                    onTap: () => onKeyTap(key),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        );
      }).toList(growable: false),
    );
  }
}

class _KeypadButton3D extends StatefulWidget {
  final String keyLabel;
  final VoidCallback onTap;

  const _KeypadButton3D({
    required this.keyLabel,
    required this.onTap,
  });

  @override
  State<_KeypadButton3D> createState() => _KeypadButton3DState();
}

class _KeypadButton3DState extends State<_KeypadButton3D> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isBackspace = widget.keyLabel == 'BACK';
    final isComma = widget.keyLabel == ',';

    final fillColor = isBackspace
        ? AppTheme.dangerRed
        : isComma
            ? AppTheme.primaryViolet
            : AppTheme.surfaceCardLight;

    final shadowColor = isBackspace
        ? AppTheme.dangerRedShadow
        : isComma
            ? AppTheme.primaryVioletShadow
            : const Color(0xFF1B0E40);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 70),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: Offset(0, _pressed ? 1.5 : 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: isBackspace
              ? const Icon(
                  Icons.backspace_rounded,
                  color: Colors.white,
                  size: 22,
                )
              : Text(
                  widget.keyLabel,
                  style: AppTheme.displayFont(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

