import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/controller/book_crud_controller.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

class BookRepositoryMock extends Mock implements BookRepository {}

class DialogServiceMock extends Mock implements DialogService {}

class BoxMock extends Mock implements Box<BookModel> {}

class BookModelMock extends Mock implements BookModel {}

void main() {
  late BookCrudController controller;
  late BookRepositoryMock bookRepository;
  late DialogServiceMock dialogService;
  late BoxMock box;

  setUpAll(() {
    registerFallbackValue(BookModelMock());
    Get.testMode = true;
  });

  setUp(() {
    bookRepository = BookRepositoryMock();
    dialogService = DialogServiceMock();
    box = BoxMock();
  });

  group("WordCrudController -", () {
    group('1_determin what controller do onInit according to screen type', () {
      test(
        "A :: when controller is initializing and controller type sended as bookAdd then editingBook must be null",
        () {
          //arrange
          controller = BookCrudController(
            bookRepository: bookRepository,
            dialogService: dialogService,
            type: BookScreenType.addBook,
          );
          //act
          controller.onInit();
          //assert
          expect(controller.editingBook, null);
        },
      );
      test(
        "B :: when controller is initializing and controller type sended as editBook then editingBook must be initialized",
        () {
          //arrange
          controller = BookCrudController(
            bookRepository: bookRepository,
            dialogService: dialogService,
            type: BookScreenType.editBook,
            bookKey: 42,
          );
          final bookMock = BookModelMock();
          when(() => bookMock.name).thenReturn('504');
          when(() => bookMock.description).thenReturn('from book');
          when(() => bookMock.color).thenReturn(1);
          when(() => bookMock.icon).thenReturn(1);
          when(() => bookMock.type).thenReturn(1);
          when(() => bookMock.level).thenReturn(1);
          when(() => bookMock.createAt).thenReturn(1);
          when(() => bookMock.id).thenReturn('5280');
          when(() => bookMock.words).thenReturn([]);

          final fakeNotifier = ValueNotifier<Box<BookModel>>(box);
          when(() => bookRepository.bookListenable).thenReturn(fakeNotifier);
          when(() => box.get(controller.bookKey)).thenReturn(bookMock);
          //act
          controller.onInit();
          //assert
          expect(controller.editingBook, bookMock);
        },
      );
    });
    group('2_update controller properties and selected words', () {
      test(
        'A :: when updateProperties function called book properties should be changed',
        () {
          //arrange
          controller = BookCrudController(
            bookRepository: bookRepository,
            dialogService: dialogService,
            type: BookScreenType.addBook,
          );

          controller.updateSelectedWords(words: []);
          controller.properties['color'] = 0;
          controller.properties['type'] = 0;
          controller.properties['icon'] = 0;
          controller.properties['level'] = 0;
          //act
          controller.updateProperty(key: 'color', value: 2);
          controller.updateProperty(key: 'type', value: 2);
          controller.updateProperty(key: 'icon', value: 2);
          controller.updateProperty(key: 'level', value: 2);
          controller.updateSelectedWords(words: [1, 2, 3, 4]);
          //assert
          expect(controller.selectedWords, equals([1, 2, 3, 4]));
          expect(controller.properties['color'], equals(2));
          expect(controller.properties['type'], equals(2));
          expect(controller.properties['icon'], equals(2));
          expect(controller.properties['level'], equals(2));
        },
      );
    });

    group('3_addBook function', () {
      test(
        'A :: when controller type is addBook and addBook function called then repo shoud add book',
        () async {
          //arrange
          controller = BookCrudController(
            bookRepository: bookRepository,
            dialogService: dialogService,
            type: BookScreenType.addBook,
          );
          controller.nameController.text = 'new book';
          controller.descriptionController.text = 'from the course';
          when(
            () => bookRepository.addBook(book: any(named: 'book')),
          ).thenAnswer((invocation) async => {});
          //act
          controller.updateSelectedWords(words: [0, 1, 2, 3, 4, 5]);
          controller.updateProperty(key: 'icon', value: 0);
          controller.updateProperty(key: 'color', value: 0);
          controller.updateProperty(key: 'type', value: 0);
          controller.updateProperty(key: 'level', value: 0);
          final either = await controller.addBook();
          //assert
          expect(either.isRight(), equals(true));
          either.fold(
            (erro) {
              fail('could not be left');
            },
            (success) {
              expect(success.successMessage, equals('New book added'));
            },
          );
        },
      );
    });
    group('4_updateBook function', () {
      test(
        "A :: when updateBook function called then editing word properties must changed and saved ",
        () async {
          //arrange
          controller = BookCrudController(
            bookRepository: bookRepository,
            dialogService: dialogService,
            type: BookScreenType.editBook,
            bookKey: 42,
          );
          
          controller.nameController.text = '504 Updated';
          controller.descriptionController.text = 'New Description';
          controller.updateProperty(key: 'color', value: 3);

          final bookMock = BookModelMock();
          
          when(() => bookMock.name).thenReturn('504');
          when(() => bookMock.description).thenReturn('from the book');
          when(() => bookMock.key).thenReturn(42);
          when(() => bookMock.icon).thenReturn(1);
          when(() => bookMock.level).thenReturn(1);
          when(() => bookMock.type).thenReturn(1);
          when(() => bookMock.color).thenReturn(1);
          when(() => bookMock.words).thenReturn([1, 2, 3]);
          when(
            () => bookMock.copyWith(
              color: any(named: 'color'),
              icon: any(named: 'icon'),
              level: any(named: 'level'),
              type: any(named: 'type'),
              name: any(named: 'name'),
              description: any(named: 'description'),
              words: any(named: 'words'),
            ),
          ).thenReturn(bookMock);
        
          controller.editingBook = bookMock;
        
          when(
            () => bookRepository.updateBook(
              key: any(named: 'key'),
              book: any(named: 'book'),
            ),
          ).thenAnswer((invocation) async => {});
          //act
          final either = await controller.updateBook();
          //assert
          expect(either.isRight(), true);
          either.fold(
            (error) {
              fail('could not return left');
            },
            (success) {
              expect(success.successMessage, '504 updated');
            },
          );
        },
      );
    });
  });
}
