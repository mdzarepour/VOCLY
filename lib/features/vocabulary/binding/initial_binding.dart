import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vocly/core/services/filter_service.dart';
import 'package:vocly/core/services/link_service.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository_imp.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/services/speech_service.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // packages -->
    Get.lazyPut(() => SharePlus.instance);
    Get.lazyPut(() => FlutterTts());

    // repositories -->
    Get.lazyPut<VocabularyRepository>(
      () => VocabularyRepository(
        booksBox: Hive.box<BookModel>(AppStrings.bookBox),
        wordsBox: Hive.box<WordModel>(AppStrings.wordBox),
      ),
      fenix: true,
    );
    Get.lazyPut<BookRepository>(
      () => Get.find<VocabularyRepository>(),
      fenix: true,
    );
    Get.lazyPut<WordRepository>(
      () => Get.find<VocabularyRepository>(),
      fenix: true,
    );
    Get.lazyPut<BackupRepository>(
      () => Get.find<VocabularyRepository>(),
      fenix: true,
    );
    // services -->
    Get.put(DialogService());
    Get.put(FilterService());
    Get.lazyPut(
      () => LinkService(sharePlus: Get.find<SharePlus>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SpeechService(flutterTts: Get.find<FlutterTts>()),
      fenix: true,
    );
  }
}
