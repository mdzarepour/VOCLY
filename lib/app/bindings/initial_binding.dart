import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/app/models/entities/book_model.dart';
import 'package:vocly/app/models/entities/word_model.dart';
import 'package:vocly/app/models/repositories/hive_vocabulary_repository.dart';
import 'package:vocly/app/models/repositories/vocabulary_repository.dart';
import 'package:vocly/app/common/constants/const_strings.dart';
import 'package:vocly/app/core/services/dialog_service.dart';
import 'package:vocly/app/core/services/speech_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // REPOSITORIES -->
    Get.lazyPut<HiveVocabularyRepository>(
      () => HiveVocabularyRepository(
        booksBox: Hive.box<BookModel>(AppStrings.bookBox),
        wordsBox: Hive.box<WordModel>(AppStrings.wordBox),
      ),
      fenix: true,
    );

    Get.lazyPut<WordRepository>(() => Get.find<HiveVocabularyRepository>(), fenix: true);
    Get.lazyPut<BookRepository>(() => Get.find<HiveVocabularyRepository>(), fenix: true);

    // SERVICES -->
    Get.put(DialogService());
    Get.lazyPut(() => SpeechService(), fenix: true);
  }
}
