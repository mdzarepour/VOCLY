import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/common/constants/const_icons.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/vocabulary/controller/book_controller.dart';
import 'package:vocly/vocabulary/controller/book_selection_controller.dart';
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
    return GetBuilder<BookSelectionController>(
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
                selectedBorderColor: getBookWidgetColor(
                  isSelected: controller.isSelected(item: book),
                  color: book.color,
                ),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    style: AppTextTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    book.name,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Icon(ConstIcons.icons[book.icon]),
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
        Text(style: AppTextTheme.titleMedium, UIStrings.thereIsNoBookYet),
      ],
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: GetBuilder<BookSelectionController>(
        builder: (controller) {
          return Row(
            children: [
              Text(UIStrings.manageBooks, style: AppTextTheme.titleMedium),
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

  Color getBookWidgetColor({
    required final bool isSelected,
    required final int color,
  }) {
    return isSelected
        ? ConstUiColors.thirdColor
        : ConstEntityColors.colors[color];
  }

  Future<void> _deleteBook({required List<BookModel> selectedBooks}) async {
    final bool? permission = await _dialogService.showDialog(
      title: AppStrings.dialogConfirmDeleteTitle,
      content: 'Are you sure about deleting these books?',
      confirmTitle: AppStrings.dialogConfirmDeleteAction,
    );

    if (permission == null || permission == false) return;
    _bookController.deleteItems(selectedItems: selectedBooks);
  }
}





