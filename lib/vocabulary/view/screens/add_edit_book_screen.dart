import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/common/widgets/expansion_widget.dart';
import 'package:vocly/common/widgets/input_widget.dart';
import 'package:vocly/core/constants/const_colors.dart';
import 'package:vocly/core/enums/enums.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/vocabulary/controller/book_controller.dart';
import 'package:vocly/vocabulary/model/book_model.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

class AddEditBookScreen extends StatefulWidget {
  const AddEditBookScreen({super.key});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _bookController = Get.find<BookController>();
  final _dialogService = Get.find<DialogService>();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _selectedColorIndex = 0;
  int _selectedBannerIndex = 1;
  List<WordModel> _selectedWords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Add new book', style: AppTextTheme.titleMedium),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text('Details', style: AppTextTheme.titleMedium),
                  SizedBox(height: 10),
                  InputWidget(
                    icon: Icons.chrome_reader_mode_outlined,
                    controller: _nameController,
                    hint: 'Name',
                  ),
                  SizedBox(height: 10),
                  InputWidget(
                    icon: Icons.description_outlined,
                    controller: _descriptionController,
                    hint: 'Description',
                  ),
                  const SizedBox(height: 30),
                  Text('Visual', style: AppTextTheme.titleMedium),
                  SizedBox(height: 10),
                  _colorSelection(),
                  SizedBox(height: 10),
                  _bannerSelection(),
                  SizedBox(height: 30),
                  Text('Words', style: AppTextTheme.titleMedium),
                  SizedBox(height: 10),
                  _wordSelection(),
                  SizedBox(height: 30),
                  _actionButtons(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wordSelection() {
    return InkWell(
      onTap: () async {
        List<WordModel> list = await Get.toNamed(
          Routes.manageWordsScreen,
          arguments: ManageWordsScreenType.add,
        );
        setState(() {
          _selectedWords = list;
        });
      },
      child: CardWidget(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text(style: AppTextTheme.titleMedium, '${_selectedWords.length}'),
            Text(style: AppTextTheme.titleMedium, 'Words'),
          ],
        ),
      ),
    );
  }

  Widget _colorSelection() {
    return ExpansionWidget(
      title: 'Color',
      children: [
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            for (int i = 0; i < ConstWordColors.colors.length; i++)
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedColorIndex = i;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  padding: i == _selectedColorIndex
                      ? EdgeInsets.all(15)
                      : EdgeInsets.all(100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: ConstWordColors.colors[i],
                  ),
                  child: CircleAvatar(
                    backgroundColor: ConstUiColors.backgroundColor,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _bannerSelection() {
    return ExpansionWidget(
      title: 'Banner',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            for (int i = 0; i < 3; i++)
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedBannerIndex = i;
                  });
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedBannerIndex == i
                          ? ConstUiColors.thirdColor
                          : ConstUiColors.backgroundColor2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/$i.jpg'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
              if (_formKey.currentState!.validate()) {
                final map = {
                  'name': _nameController.text,
                  'description': _descriptionController.text,
                  'color': _selectedColorIndex,
                  'banner': _selectedBannerIndex,
                  'words': _selectedWords,
                };
                final BookModel model = BookModel.fromMap(map: map);
                _addBook(model: model);
              }
            },
            child: CardWidget(
              height: 70,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done),
                  Text('Done', style: AppTextTheme.titleMedium),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () => Get.back(),
            child: CardWidget(
              height: 70,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel_outlined),
                  Text('Cancel', style: AppTextTheme.titleMedium),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addBook({required final BookModel model}) async {
    final bool isBookExist = _bookController.isItemExist(name: model.name);

    if (!isBookExist) {
      _bookController.addItem(model: model);
      return;
    }
    final bool? permission = await _dialogService.showDialog(
      title: 'Duplicated book!',
      content: 'Are you sure want to add duplicated book?',
      confirmTitle: 'Yes add',
    );
    if (permission!) {
      _bookController.addItem(model: model);
    } else {
      Get.back();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }
}
