import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// Servico enxuto para feedbacks sonoros e hapticos no Android.
/// Utiliza fallback automatico para HapticFeedback e SystemSound do Flutter
/// caso o dispositivo nao possua motor de vibracao customizado ou os arquivos
/// de audio ainda nao estejam presentes nos assets.
class FeedbackService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Feedback curto a cada segundo final da contagem regressiva.
  Future<void> playCountdownTick() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {
      // Ignora silenciosamente se o hardware nao suportar
    }
  }

  /// Feedback ao iniciar o timer principal de 70 segundos.
  Future<void> playStartAction() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: 150);
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (_) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Feedback intenso sonoro e haptico quando o tempo de 70 segundos esgota.
  Future<void> playTimeUpAlert() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(pattern: [0, 300, 150, 400]);
      } else {
        await HapticFeedback.heavyImpact();
      }
    } catch (_) {
      await HapticFeedback.heavyImpact();
    }

    try {
      await _audioPlayer.play(AssetSource('audio/time_up.mp3'));
    } catch (_) {
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Feedback de vitoria imediata quando uma equipe atinge a pontuacao maxima.
  Future<void> playVictoryAlert() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 500]);
      }
    } catch (_) {}

    try {
      await _audioPlayer.play(AssetSource('audio/victory.mp3'));
    } catch (_) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

