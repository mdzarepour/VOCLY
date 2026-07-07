import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/controller/book_controller.dart';
import 'package:vocly/shared/constants/const_icons.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/widgets/expansion_widget.dart';
import 'package:vocly/shared/widgets/input_widget.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

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
  int _selectedLevelIndex = 0;
  int _selectedIconIndex = 0;
  int _selectedTypeIndex = 0;
  List<String> _selectedWords = [];

  late final BookModel? _editingBook;
  late final bool _isEditingType;

  @override
  void initState() {
    super.initState();
    final type = Get.arguments[0] as BookScreenType;
    _isEditingType = type == BookScreenType.editBook ? true : false;

    if (Get.arguments[1] == null) return;

    _editingBook = Get.arguments[1] as BookModel;
    _nameController.text = _editingBook!.name;
    _descriptionController.text = _editingBook.description;
    _selectedColorIndex = _editingBook.color;
    _selectedIconIndex = _editingBook.icon;
    _selectedWords = List.from(_editingBook.words);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            _isEditingType ? 'Edit book' : UIStrings.addNewBook,
            style: AppTextTheme.titleMedium,
          ),
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
                    Text(UIStrings.details, style: AppTextTheme.titleMedium),
                    SizedBox(height: 10),
                    InputWidget(
                      icon: Icons.chrome_reader_mode_outlined,
                      controller: _nameController,
                      hint: UIStrings.name,
                    ),
                    SizedBox(height: 10),
                    InputWidget(
                      icon: Icons.description_outlined,
                      controller: _descriptionController,
                      hint: UIStrings.description,
                    ),
                    SizedBox(height: 10),
                    _typeSelection(),
                    SizedBox(height: 10),
                    _difficultySelection(),
                    const SizedBox(height: 30),
                    Text(UIStrings.visual, style: AppTextTheme.titleMedium),
                    SizedBox(height: 10),
                    _colorSelection(),
                    SizedBox(height: 10),
                    _iconSelection(),
                    SizedBox(height: 30),
                    Text(UIStrings.words, style: AppTextTheme.titleMedium),
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
      ),
    );
  }

  Widget _typeSelection() {
    return ExpansionWidget(
      title: UIStrings.type,
      children: [
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            for (int i = 0; i < BookTypes.bookTypes.length; i++)
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedTypeIndex = i;
                  });
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    border: Border.all(color: ConstUiColors.backgroundColor2),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: i == _selectedTypeIndex
                        ? ConstUiColors.backgroundColor2
                        : ConstUiColors.forthColor,
                  ),
                  child: Center(
                    child: Text(
                      BookTypes.bookTypes[i],
                      style: AppTextTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _difficultySelection() {
    return ExpansionWidget(
      title: UIStrings.difficulty,
      children: [
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            for (int i = 0; i < EntityLevel.levels.length; i++)
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedLevelIndex = i;
                  });
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    border: Border.all(color: ConstUiColors.backgroundColor2),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: i == _selectedLevelIndex
                        ? ConstUiColors.backgroundColor2
                        : ConstUiColors.forthColor,
                  ),
                  child: Center(
                    child: Text(
                      EntityLevel.levels[i],
                      style: AppTextTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _wordSelection() {
    return InkWell(
      onTap: () async {
        List<WordModel> list = await Get.toNamed(
          Routes.manageWordsScreen,
          arguments: [ManageWordsScreenType.addWordToBook, _selectedWords],
        );
        setState(() {
          _selectedWords = list.map((e) => e.id).toList();
        });
      },
      child: CardWidget(
        height: 50,
        child: Center(
          child: Text(style: AppTextTheme.titleMedium, 'Selected words'),
        ),
      ),
    );
  }

  Widget _colorSelection() {
    return ExpansionWidget(
      title: UIStrings.color,
      children: [
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            for (int i = 0; i < ConstEntityColors.colors.length; i++)
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
                    color: ConstEntityColors.colors[i],
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

  Widget _iconSelection() {
    return ExpansionWidget(
      title: UIStrings.icon,
      children: [
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            for (int i = 0; i < ConstIcons.icons.length; i++)
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIconIndex = i;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: ConstUiColors.backgroundColor2),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: i == _selectedIconIndex
                        ? ConstUiColors.backgroundColor2
                        : ConstUiColors.forthColor,
                  ),
                  child: Icon(ConstIcons.icons[i]),
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
                  AppStrings.keyName: _nameController.text,
                  AppStrings.keyDescription: _descriptionController.text,
                  AppStrings.keyColor: _selectedColorIndex,
                  AppStrings.keyBanner: _selectedIconIndex,
                  AppStrings.keyWords: _selectedWords,
                  AppStrings.keyType: _selectedTypeIndex,
                  AppStrings.level: _selectedLevelIndex,
                };
                if (_isEditingType) {
                  _editingBook!.updateBook(map: map);
                  _updateBook();
                } else {
                  _addBook(map: map);
                }
              }
            },
            child: CardWidget(
              selectedBorderColor: ConstUiColors.positiveColor,
              height: 70,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_isEditingType ? Icons.edit : Icons.done),
                  Text(UIStrings.done, style: AppTextTheme.titleMedium),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () => Get.back(),
            child: CardWidget(
              selectedBorderColor: ConstUiColors.errorColor,
              height: 70,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel_outlined),
                  Text(UIStrings.cancel, style: AppTextTheme.titleMedium),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateBook() {
    _bookController.updateCurrentBook(newBook: _editingBook!);
    Get.back();
  }

  Future<void> _addBook({required final Map<String, dynamic> map}) async {
    final bool isBookExist = _bookController.isBookExist(
      name: map[AppStrings.keyName],
    );
    if (!isBookExist) {
      _bookController.addBook(map: map);
      return;
    }
    final bool? permission = await _dialogService.showDialog(
      title: AppStrings.dialogDuplicatedBookTitle,
      content: AppStrings.dialogDuplicatedBookContent,
      confirmTitle: AppStrings.dialogDuplicatedBookConfirm,
    );
    if (permission!) {
      _bookController.addBook(map: map);
    } else {
      Get.back();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }
}
