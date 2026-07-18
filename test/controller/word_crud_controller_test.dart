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

class WordModelMock extends Mock implements WordModel {}

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
  });

  group('WordCrudController -', () {
    group("1_determin what controller do onInit according to screen type", () {
      test(
        "َA :: when controller type sended as addWord then editingWord must be null",
        () {
          controller = WordCrudController(
            dialogService: dialogService,
            wordRepository: wordRepository,
            type: WordScreenType.addWord,
          );
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
          controller = WordCrudController(
            dialogService: dialogService,
            wordRepository: wordRepository,
            type: WordScreenType.editWord,
            wordKey: 42,
          );
          final wordMock = WordModelMock();
          when(() => wordMock.name).thenReturn('Rabbit');
          when(() => wordMock.meaning).thenReturn('Animal');
          when(() => wordMock.example).thenReturn('there is a rabbit');
          when(() => wordMock.color).thenReturn(1);
          when(() => wordMock.icon).thenReturn(1);
          when(() => wordMock.type).thenReturn(1);
          when(() => wordMock.level).thenReturn(1);

          final fakeNotifier = ValueNotifier<Box<WordModel>>(box);
          when(() => wordRepository.wordListenable).thenReturn(fakeNotifier);
          when(() => box.get(controller.wordKey)).thenReturn(wordMock);
          //act
          controller.onInit();
          //assert
          expect(controller.editingWord, wordMock);
        },
      );
    });
    group("2_word property selection function", () {
      test(
        "A :: controller must change word property map when changeProperty function called",
        () {
          //arrange
          controller = WordCrudController(
            dialogService: dialogService,
            wordRepository: wordRepository,
            type: WordScreenType.addWord,
          );
          controller.properties['icon'] = 2;
          controller.properties['color'] = 2;
          controller.properties['type'] = 2;
          controller.properties['level'] = 2;
          //act
          controller.updateProperty(key: 'icon', value: 1);
          controller.updateProperty(key: 'color', value: 1);
          controller.updateProperty(key: 'type', value: 1);
          controller.updateProperty(key: 'level', value: 1);
          //assert
          final p = controller.properties;
          expect(p['icon'], equals(1));
          expect(p['color'], equals(1));
          expect(p['type'], equals(1));
          expect(p['level'], equals(1));
        },
      );
    });
    group("3_word add function", () {
      test(
        "A :: controller must add a word when addWord function called and word not exist",
        () async {
          controller = WordCrudController(
            dialogService: dialogService,
            wordRepository: wordRepository,
            type: WordScreenType.addWord,
          );
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
          controller = WordCrudController(
            dialogService: dialogService,
            wordRepository: wordRepository,
            type: WordScreenType.addWord,
          );
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
          controller = WordCrudController(
            dialogService: dialogService,
            wordRepository: wordRepository,
            type: WordScreenType.addWord,
          );
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

    test(
      "A :: controller must update a word and return AppSuccess when updateWord function called successfully",
      () async {
        //arrange
        controller = WordCrudController(
          type: WordScreenType.editWord,
          dialogService: dialogService,
          wordRepository: wordRepository,
          wordKey: 42,
        );

        final fakeWord = WordModelMock();

        when(() => fakeWord.key).thenReturn(42);
        when(() => fakeWord.name).thenReturn('Rabbit');
        when(() => fakeWord.meaning).thenReturn('Animal');
        when(() => fakeWord.example).thenReturn('There is a rabbit');
        when(() => fakeWord.icon).thenReturn(1);
        when(() => fakeWord.color).thenReturn(1);
        when(() => fakeWord.type).thenReturn(1);
        when(() => fakeWord.level).thenReturn(1);

        when(
          () => fakeWord.copyWith(
            name: any(named: 'name'),
            meaning: any(named: 'meaning'),
            example: any(named: 'example'),
            color: any(named: 'color'),
            icon: any(named: 'icon'),
            type: any(named: 'type'),
            level: any(named: 'level'),
          ),
        ).thenReturn(fakeWord);

        controller.editingWord = fakeWord;
        when(
          () => wordRepository.updateWord(
            key: any(named: 'key'),
            word: any(named: 'word'),
          ),
        ).thenAnswer((invocation) async => {});
        //act
        final either = await controller.updateWord();
        //assert
        expect(either.isRight(), equals(true));
        either.fold(
          (error) {
            fail('could not be a keft');
          },
          (success) {
            expect(success.successMessage, equals('updated'));
          },
        );
      },
    );
  });

  tearDown(() {
    controller.dispose();
  });
}
