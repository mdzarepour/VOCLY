import 'package:flutter_tts/flutter_tts.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class SpeechService {
  final FlutterTts flutterTts;
  SpeechService({required this.flutterTts});

  Future<void> initEssentials() async {
    await flutterTts.setLanguage(AppStrings.languageEnUs);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
  }

  Future<void> speak({required final String text}) async {
    await flutterTts.speak(text);
  }

  Future<void> stopSpeech() async {
    await flutterTts.stop();
  }
}
