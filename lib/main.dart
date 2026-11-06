import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/mimica/presentation/pages/game_flow_shell_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Trava a orientacao em retrato para otimizar a experiencia Party Game no Android
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ProviderScope(
      child: MimicaPartyApp(),
    ),
  );
}

class MimicaPartyApp extends StatelessWidget {
  const MimicaPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mimica party',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const GameFlowShellPage(),
    );
  }
}
