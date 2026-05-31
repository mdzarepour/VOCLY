import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> initEssentials() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> speak({required final String text}) async {
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeech() async {
    await _flutterTts.stop();
  }
}
