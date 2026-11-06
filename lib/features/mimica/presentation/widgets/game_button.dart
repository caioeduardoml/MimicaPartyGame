import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';

/// Variantes de cores pre-configuradas para o [GameButton].
enum GameButtonStyle {
  primary(
    fillColor: AppTheme.primaryViolet,
    shadowColor: AppTheme.primaryVioletShadow,
    textColor: Colors.white,
  ),
  yellow(
    fillColor: AppTheme.accentYellow,
    shadowColor: AppTheme.accentYellowShadow,
    textColor: Color(0xFF1F1235),
  ),
  success(
    fillColor: AppTheme.successGreen,
    shadowColor: AppTheme.successGreenShadow,
    textColor: Colors.white,
  ),
  danger(
    fillColor: AppTheme.dangerRed,
    shadowColor: AppTheme.dangerRedShadow,
    textColor: Colors.white,
  ),
  warning(
    fillColor: AppTheme.warningOrange,
    shadowColor: AppTheme.warningOrangeShadow,
    textColor: Colors.white,
  ),
  cyan(
    fillColor: AppTheme.infoCyan,
    shadowColor: AppTheme.infoCyanShadow,
    textColor: Colors.white,
  ),
  neutral(
    fillColor: AppTheme.surfaceCardLight,
    shadowColor: Color(0xFF1E1145),
    textColor: Colors.white,
  );

  final Color fillColor;
  final Color shadowColor;
  final Color textColor;

  const GameButtonStyle({
    required this.fillColor,
    required this.shadowColor,
    required this.textColor,
  });
}

/// Botao 3D Tatil estilo Party Game / Casual Game.
///
/// Caracteristicas:
/// - Preenchimento solido vibrante sem bordas neon finas.
/// - Cantos levemente arredondados (`borderRadius = 18` por padrao, fugindo da pilula exagerada).
/// - Sombra solida projetada na parte inferior (`BoxShadow` com `blurRadius: 0` e offset vertical)
///   simulando a base 3D fisica do botao.
/// - Microinteracao ao toque: usa `GestureDetector` + `AnimatedScale` e deslocamento vertical
///   para o botao "afundar" fisicamente quando pressionado.
class GameButton extends StatefulWidget {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final GameButtonStyle buttonStyle;
  final Color? customFillColor;
  final Color? customShadowColor;
  final Color? customTextColor;
  final double height;
  final double borderRadius;
  final double fontSize;
  final double depth;
  final EdgeInsetsGeometry padding;

  const GameButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
    this.buttonStyle = GameButtonStyle.primary,
    this.customFillColor,
    this.customShadowColor,
    this.customTextColor,
    this.height = 64,
    this.borderRadius = 18,
    this.fontSize = 20,
    this.depth = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null;

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = _isEnabled
        ? (widget.customFillColor ?? widget.buttonStyle.fillColor)
        : Colors.grey.shade700;
    final shadowColor = _isEnabled
        ? (widget.customShadowColor ?? widget.buttonStyle.shadowColor)
        : Colors.grey.shade900;
    final textColor = _isEnabled
        ? (widget.customTextColor ?? widget.buttonStyle.textColor)
        : Colors.white54;

    final currentOffset = _isPressed ? widget.depth * 0.7 : 0.0;
    final currentShadowHeight =
        _isPressed ? widget.depth * 0.3 : widget.depth;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOutQuad,
        child: SizedBox(
          height: widget.height + widget.depth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOutQuad,
            margin: EdgeInsets.only(
              top: currentOffset,
              bottom: currentShadowHeight,
            ),
            padding: widget.padding,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                // Base 3D solida inferior
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(0, currentShadowHeight),
                  blurRadius: 0,
                ),
                // Sombra suave de ambientacao no fundo
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  offset: Offset(0, currentShadowHeight + 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 14),
                ] else if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: textColor,
                    size: widget.fontSize + 8,
                  ),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: widget.subtitle != null
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.label,
                        textAlign: widget.subtitle != null
                            ? TextAlign.left
                            : TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.displayFont(
                          fontSize: widget.fontSize,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.bodyFont(
                            fontSize: 13,
                            color: textColor.withValues(alpha: 0.88),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 12),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Botao circular 3D tatil ideal para os botoes de + e - na configuracao de equipes.
class GameIconButton3D extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final GameButtonStyle buttonStyle;
  final double size;

  const GameIconButton3D({
    super.key,
    required this.icon,
    required this.onPressed,
    this.buttonStyle = GameButtonStyle.primary,
    this.size = 44,
  });

  @override
  State<GameIconButton3D> createState() => _GameIconButton3DState();
}

class _GameIconButton3DState extends State<GameIconButton3D> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final fillColor =
        _isEnabled ? widget.buttonStyle.fillColor : Colors.white12;
    final shadowColor =
        _isEnabled ? widget.buttonStyle.shadowColor : Colors.black26;
    final iconColor =
        _isEnabled ? widget.buttonStyle.textColor : Colors.white38;

    return GestureDetector(
      onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: _isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel:
          _isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: () {
        if (_isEnabled) {
          HapticFeedback.selectionClick();
          widget.onPressed?.call();
        }
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: fillColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: Offset(0, _isPressed ? 1.5 : 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: iconColor,
            size: widget.size * 0.55,
          ),
        ),
      ),
    );
  }
}

