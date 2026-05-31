import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/vocabulary/model/book_model.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

class HiveServices extends GetxService {
  Future<void> initHiveEssentials() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WordModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BookModelAdapter());
    }

    await Hive.openBox<WordModel>('WordBox');
    await Hive.openBox<BookModel>('BookBox');
  }
}
