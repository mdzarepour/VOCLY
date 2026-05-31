import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/core/constants/const_colors.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/vocabulary/controller/book_controller.dart';
import 'package:vocly/vocabulary/controller/selection_controller.dart';
import 'package:vocly/vocabulary/model/book_model.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({super.key});

  @override
  State<ManageBooksScreen> createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  final _dialogService = Get.find<DialogService>();
  final _bookController = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: GetBuilder<BookController>(
        builder: (controller) {
          final books = controller.items;
          return books.isEmpty
              ? _emptyState()
              : GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1 / 1,
                  ),
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    final book = books[index];
                    return _bookWidget(book: book);
                  },
                );
        },
      ),
    );
  }

  Widget _bookWidget({required final BookModel book}) {
    return GetBuilder<SelectionController>(
      builder: (controller) {
        return InkWell(
          onLongPress: () => controller.changeSelectionMode(item: book),
          onTap: () {
            if (controller.isSelectionMode) {
              controller.selectItem(item: book);
            } else {
              Get.toNamed(Routes.readBookScreen, arguments: book);
            }
          },
          child: Stack(
            children: [
              CardWidget(
                selectedBorderColor: controller.isSelected(item: book)
                    ? ConstUiColors.thirdColor
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: double.infinity),
                    Text(
                      textAlign: TextAlign.center,
                      style: AppTextTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      book.name,
                    ),
                    SizedBox(height: 15),
                    Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.titleMedium,
                      '${book.words.length} Words',
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: ConstWordColors.colors[book.color],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _emptyState() {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Icon(Icons.search_off_outlined),
        Text(style: AppTextTheme.titleMedium, 'there is no book yet!'),
      ],
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: GetBuilder<SelectionController>(
        builder: (controller) {
          return Row(
            children: [
              Text('Manage books', style: AppTextTheme.titleMedium),
              const Spacer(),
              if (controller.isSelectionMode)
                InkWell(
                  onTap: () {
                    _deleteBook(
                      selectedBooks: controller.selectedItems.cast<BookModel>(),
                    );
                  },
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Icon(Icons.delete_outline),
                  ),
                ),

              SizedBox(width: 10),
              //TODO change to icon
              InkWell(
                onTap: () => controller.selectAllItems(),
                child: Text(
                  controller.selectButtonTitle,
                  style: AppTextTheme.titleMedium,
                ),
              ),
              SizedBox(width: 20),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteBook({required List<BookModel> selectedBooks}) async {
    final bool? permision = await _dialogService.showDialog(
      title: 'Deleting!',
      content: 'Are you sure about deleting these books?',
      confirmTitle: 'delete',
    );

    if (permision == null || permision == false) return;
    _bookController.deleteItems(selectedItems: selectedBooks);
  }
}
