import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/controller/word_crud_controller.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

class WordRepositoryMock extends Mock implements WordRepository {}

class BoxMock extends Mock implements Box<WordModel> {}

class DialogServiceMock extends Mock implements DialogService {}

class FakeWordModel extends Fake implements WordModel {}

void main() {
  late WordCrudController controller;
  late DialogServiceMock dialogService;
  late WordRepositoryMock wordRepository;
  late Box<WordModel> box;

  setUpAll(() {
    Get.testMode = true;
    registerFallbackValue(FakeWordModel());
  });

  setUp(() {
    dialogService = DialogServiceMock();
    wordRepository = WordRepositoryMock();
    box = BoxMock();

    controller = WordCrudController(
      dialogService: dialogService,
      wordRepository: wordRepository,
      type: WordScreenType.addWord,
    );
  });

  group('WordCrudController -', () {
    group("1_word property selection function", () {
      test(
        "A :: controller must change word property map when changeProperty function called",
        () {
          //act
          controller.updateProperty(key: 'icon', value: 1);
          controller.updateProperty(key: 'color', value: 2);
          controller.updateProperty(key: 'type', value: 3);
          controller.updateProperty(key: 'level', value: 4);
          //assert
          final p = controller.properties;
          expect(p['icon'], equals(1));
          expect(p['color'], equals(2));
          expect(p['type'], equals(3));
          expect(p['level'], equals(4));
        },
      );
    });
    group("2_word add function", () {
      test(
        "A :: controller must add a word when addWord function called and word not exist",
        () async {
          //arrange
          controller.nameController.text = 'Apple';
          when(
            () => wordRepository.isWordExist(name: any(named: 'name')),
          ).thenReturn(false);
          when(
            () => wordRepository.addWord(word: any(named: 'word')),
          ).thenAnswer((invocation) async => {});
          //act
          final either = await controller.addWord();
          //assert
          expect(either.isRight(), equals(true));
          either.fold(
            (error) {
              fail('result could not be a left');
            },
            (success) {
              expect(success.successMessage, equals('Apple Added'));
            },
          );
        },
      );
      test(
        "B :: controller must add a word when addWord function called then word exist but permision is allow for duplicated word",
        () async {
          //arrange
          controller.nameController.text = 'Pig';
          when(
            () => wordRepository.isWordExist(name: any(named: 'name')),
          ).thenReturn(true);
          when(
            () => dialogService.showDialog(
              confirmTitle: any(named: 'confirmTitle'),
              content: any(named: 'content'),
              title: any(named: 'title'),
            ),
          ).thenAnswer((invocation) async => true);
          when(
            () => wordRepository.addWord(word: any(named: 'word')),
          ).thenAnswer((invocation) async => {});
          //act
          final either = await controller.addWord();
          //assert
          expect(either.isRight(), equals(true));
          either.fold(
            (error) {
              fail('result could not be a left');
            },
            (success) {
              expect(success.successMessage, equals('Pig Added'));
            },
          );
        },
      );

      test(
        "C :: controller dont add a word when addWord function called then word exist but permision is denied for duplicated word",
        () async {
          //arrange
          controller.nameController.text = 'Sheep';
          when(
            () => wordRepository.isWordExist(name: any(named: 'name')),
          ).thenReturn(true);
          when(
            () => dialogService.showDialog(
              title: any(named: 'title'),
              content: any(named: 'content'),
              confirmTitle: any(named: 'confirmTitle'),
            ),
          ).thenAnswer((invocation) async => false);
          //act
          final either = await controller.addWord();
          //assert
          expect(either.isLeft(), equals(true));
          either.fold(
            (error) {
              expect(error.errorMessage, equals('Permission Denied'));
            },
            (success) {
              fail('could not return right');
            },
          );
        },
      );
    });
    group("3_determin what controller do onInit according to screen type", () {
      test(
        "َA :: when controller type sended as addWord then editingWord must be null",
        () {
          //act
          controller.onInit();
          //assert
          expect(controller.editingWord, equals(null));
        },
      );
      test(
        "B ::: when controller type sended as editWord then editingWord must be initialize",
        () {
          //arrange
          final fakeWord = WordModel(
            name: 'Cat',
            meaning: 'animal',
            example: 'There is a cat',
            id: '1212',
            icon: 5,
            type: 1,
            color: 3,
            level: 2,
            createAt: 1212,
          );
          controller = WordCrudController(
            dialogService: dialogService,
            wordRepository: wordRepository,
            type: WordScreenType.editWord,
            wordKey: 42,
          );
          final fakeNotifier = ValueNotifier<Box<WordModel>>(box);
          when(() => wordRepository.wordListenable).thenReturn(fakeNotifier);
          when(() => box.get(42)).thenReturn(fakeWord);
          //act
          controller.onInit();
          //assert
          expect(controller.editingWord!.name, equals('Cat'));
          expect(controller.editingWord!.meaning, equals('animal'));
          expect(controller.editingWord!.example, equals('There is a cat'));
          expect(controller.editingWord!.icon, equals(5));
          expect(controller.editingWord!.type, equals(1));
          expect(controller.editingWord!.color, equals(3));
          expect(controller.editingWord!.level, equals(2));
          expect(controller.editingWord!.id, equals('1212'));
          expect(controller.editingWord!.createAt, equals(1212));
        },
      );
    });
  });
  group("4_word update function ", () {
    test("A :: controller will update word if type is wordEdit ", () async {
      
    });
  });

  tearDown(() {
    controller.dispose();
  });
}
