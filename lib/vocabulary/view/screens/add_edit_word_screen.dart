import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/common/widgets/expansion_widget.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/common/constants/const_icons.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/widgets/input_widget.dart';
import 'package:vocly/core/enums/enums.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/vocabulary/controller/word_controller.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

class AddEditWordScreen extends StatefulWidget {
  const AddEditWordScreen({super.key});

  @override
  State<AddEditWordScreen> createState() => _AddEditWordScreenState();
}

class _AddEditWordScreenState extends State<AddEditWordScreen> {
  final _dialogService = Get.find<DialogService>();
  final _wordController = Get.find<WordController>();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _meaningController = TextEditingController();
  final _exampleController = TextEditingController();

  int _selectedIconIndex = 0;
  int _selectedTypeIndex = 0;
  int _selectedColorIndex = 0;

  late final bool _isEditingMode;
  late final WordModel? editingWord;

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  void _initFields() {
    final type = Get.arguments[0] as WordScreenType;
    editingWord = Get.arguments[1] ;
    _isEditingMode = type == WordScreenType.editWord ? true : false;

    if (editingWord == null) return;
    _nameController.text = editingWord!.name!;
    _meaningController.text = editingWord!.meaning!;
    _exampleController.text = editingWord!.example!;
    _selectedIconIndex = editingWord!.icon!;
    _selectedTypeIndex = editingWord!.type!;
    _selectedColorIndex = editingWord!.color!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            _isEditingMode ? 'Edit word' : 'Add new word',
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
                      icon: Icons.language,
                      controller: _nameController,
                      hint: UIStrings.name,
                    ),
                    const SizedBox(height: 15),
                    InputWidget(
                      icon: Icons.lightbulb_outline,
                      controller: _meaningController,
                      hint: UIStrings.meaning,
                    ),
                    const SizedBox(height: 15),
                    InputWidget(
                      icon: Icons.newspaper_outlined,
                      controller: _exampleController,
                      hint: UIStrings.example,
                    ),
                    const SizedBox(height: 30),
                    Text(UIStrings.visual, style: AppTextTheme.titleMedium),
                    SizedBox(height: 10),
                    _iconSelection(),
                    const SizedBox(height: 15),
                    _typeSelection(context),
                    const SizedBox(height: 15),
                    _colorSelection(),
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

  Widget _typeSelection(BuildContext context) {
    return ExpansionWidget(
      title: UIStrings.type,
      children: [
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            for (int i = 0; i < ConstWordTypes.wordTypes.length; i++)
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
                      ConstWordTypes.wordTypes[i],
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
                final Map<String, dynamic> map = {
                  AppStrings.keyName: _nameController.text,
                  AppStrings.keyMeaning: _meaningController.text,
                  AppStrings.keyExample: _exampleController.text,
                  AppStrings.keyIcon: _selectedIconIndex,
                  AppStrings.keyType: _selectedTypeIndex,
                  AppStrings.keyColor: _selectedColorIndex,
                };

                if (_isEditingMode) {
                  editingWord!.updateWordModel(map: map);
                  _updateWord();
                } else {
                  final WordModel model = WordModel.fromMap(map);
                  _addWord(model: model);
                }
              }
            },
            child: CardWidget(
              height: 70,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_isEditingMode ? Icons.edit_outlined : Icons.done),
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

  void _updateWord() {
    _wordController.updateCurrentItem(freshModel: editingWord!);
    Get.back();
  }

  Future<void> _addWord({required final WordModel model}) async {
    final bool isWordExist = _wordController.isItemExist(name: model.name!);

    if (!isWordExist) {
      _wordController.addItem(model: model);
      return;
    }

    final bool? permission = await _dialogService.showDialog(
      title: AppStrings.dialogDuplicatedWordTitle,
      content: AppStrings.dialogDuplicatedWordContent,
      confirmTitle: AppStrings.dialogDuplicatedWordConfirm,
    );

    if (permission!) {
      _wordController.addItem(model: model);
    } else {
      Get.back();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
  }
}





















