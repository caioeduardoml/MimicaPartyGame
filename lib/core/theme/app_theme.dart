import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System e Tema Global estilo "Party Game" Casual 3D.
/// Substitui o visual escuro/neon generico por gradientes ricos,
/// tipografia arredondada (Fredoka + Nunito) e cores vibrantes.
abstract final class AppTheme {
  // ===========================================================================
  // PALETA DE CORES PARTY GAME
  // ===========================================================================
  static const Color bgDeepIndigo = Color(0xFF1A103C);
  static const Color bgVibrantPurple = Color(0xFF3B1877);
  static const Color bgRoyalViolet = Color(0xFF251351);

  static const Color surfaceCard = Color(0xFF2E1C64);
  static const Color surfaceCardLight = Color(0xFF3E2785);

  static const Color primaryViolet = Color(0xFF8B5CF6);
  static const Color primaryVioletShadow = Color(0xFF5B21B6);

  static const Color accentYellow = Color(0xFFFFCA28);
  static const Color accentYellowShadow = Color(0xFFC79100);

  static const Color successGreen = Color(0xFF22C55E);
  static const Color successGreenShadow = Color(0xFF15803D);

  static const Color warningOrange = Color(0xFFFF8A00);
  static const Color warningOrangeShadow = Color(0xFFC25E00);

  static const Color dangerRed = Color(0xFFEF4444);
  static const Color dangerRedShadow = Color(0xFFB91C1C);

  static const Color infoCyan = Color(0xFF06B6D4);
  static const Color infoCyanShadow = Color(0xFF0E7490);

  // Mantem aliases de compatibilidade com as telas existentes antes da Etapa 2
  static const Color backgroundDark = bgDeepIndigo;
  static const Color primaryPurple = primaryViolet;
  static const Color accentAmber = accentYellow;

  // ===========================================================================
  // DECORACOES E GRADIENTES DE FUNDO
  // ===========================================================================

  /// BoxDecoration global para envolver os Scaffolds das telas com um
  /// gradiente linear/radial vibrante digno de Party Game.
  static const BoxDecoration backgroundGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF2E1460),
        Color(0xFF1E0E42),
        Color(0xFF12082B),
      ],
      stops: [0.0, 0.55, 1.0],
    ),
  );

  // ===========================================================================
  // TIPOGRAFIA (FREDOKA PARA TITULOS/NUMEROS + NUNITO PARA CORPO)
  // ===========================================================================

  /// Fonte pesada, arredondada e divertida para Titulos, Placar e Cronometro Gigante.
  static TextStyle displayFont({
    double fontSize = 28,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.w700,
    double letterSpacing = 0.8,
    double? height,
    List<Shadow>? shadows,
  }) {
    return GoogleFonts.fredoka(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadows,
    );
  }

  /// Fonte limpa, amigavel e altamente legivel para textos de apoio e regras.
  static TextStyle bodyFont({
    double fontSize = 16,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
  }) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
    );
  }

  // ===========================================================================
  // THEMEDATA GLOBAL DO FLUTTER
  // ===========================================================================
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.nunitoTextTheme(
      ThemeData.dark().textTheme,
    );

    final partyTextTheme = baseTextTheme.copyWith(
      displayLarge: displayFont(fontSize: 56),
      displayMedium: displayFont(fontSize: 42),
      displaySmall: displayFont(fontSize: 32),
      headlineLarge: displayFont(fontSize: 28),
      headlineMedium: displayFont(fontSize: 24),
      headlineSmall: displayFont(fontSize: 20),
      titleLarge: displayFont(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: bodyFont(fontSize: 18, fontWeight: FontWeight.w700),
      bodyLarge: bodyFont(fontSize: 16, fontWeight: FontWeight.w600),
      bodyMedium: bodyFont(fontSize: 15, color: Colors.white.withValues(alpha: 0.9)),
      labelLarge: displayFont(fontSize: 18, fontWeight: FontWeight.w700),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        surface: surfaceCard,
        primary: primaryViolet,
        onPrimary: Colors.white,
        secondary: accentYellow,
        onSecondary: Color(0xFF1F1235),
        error: dangerRed,
        onError: Colors.white,
      ),
      textTheme: partyTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: displayFont(
          fontSize: 24,
          color: Colors.white,
          letterSpacing: 1.2,
          shadows: const [
            Shadow(
              color: Colors.black45,
              offset: Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryViolet,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: displayFont(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accentYellow,
        inactiveTrackColor: Colors.black26,
        thumbColor: accentYellow,
        overlayColor: accentYellow.withValues(alpha: 0.2),
        trackHeight: 10,
      ),
    );
  }
}

/// Wrapper reutilizavel para aplicar o fundo em gradiente vibrante em todas as telas.
class PartyGradientBackground extends StatelessWidget {
  final Widget child;

  const PartyGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppTheme.backgroundGradientDecoration,
      child: child,
    );
  }
}
