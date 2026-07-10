import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/core/services/link_service.dart';
import 'package:vocly/core/services/platform_service.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository_imp.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/services/speech_service.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:share_plus/share_plus.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ================ Packages ===============================================

    Get.lazyPut(() => FlutterTts(), fenix: true);

    // ================ Repositories ===========================================

    Get.lazyPut<VocabularyRepository>(
      () => VocabularyRepository(
        booksBox: Hive.box<BookModel>(AppStrings.bookBox),
        wordsBox: Hive.box<WordModel>(AppStrings.wordBox),
      ),
      fenix: true,
    );
    
    Get.lazyPut<BookRepository>(() => Get.find<VocabularyRepository>(), fenix: true);
    Get.lazyPut<WordRepository>(() => Get.find<VocabularyRepository>(), fenix: true);
    Get.lazyPut<BackupRepository>(() => Get.find<VocabularyRepository>(), fenix: true);

    // ================ Services ===============================================
    
    Get.put(DialogService()); 
    Get.lazyPut(() => LinkService(sharePlus: SharePlus.instance), fenix: true);
    Get.lazyPut(() => SpeechService(flutterTts: Get.find<FlutterTts>()), fenix: true);
    Get.lazyPut(() => PlatformService(), fenix: true);
  }
}
