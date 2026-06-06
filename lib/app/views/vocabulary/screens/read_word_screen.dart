import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/app/controllers/vocabulary/word_controller.dart';
import 'package:vocly/app/common/theme/app_text_theme.dart';
import 'package:vocly/app/common/widgets/card_widget.dart';
import 'package:vocly/app/common/widgets/expansion_widget.dart';
import 'package:vocly/app/common/constants/const_colors.dart';
import 'package:vocly/app/common/constants/const_icons.dart';
import 'package:vocly/app/common/constants/const_strings.dart';
import 'package:vocly/app/core/enums/enums.dart';
import 'package:vocly/app/core/router/app_router.dart';
import 'package:vocly/app/core/services/speech_service.dart';
import 'package:vocly/app/controllers/vocabulary/spelling_controller.dart';

import 'package:vocly/app/models/entities/word_model.dart';

class ReadWordScreen extends StatefulWidget {
  const ReadWordScreen({super.key});

  @override
  State<ReadWordScreen> createState() => _ReadWordScreenState();
}

class _ReadWordScreenState extends State<ReadWordScreen> {
  final _wordController = Get.find<WordController>();
  final _speechService = Get.find<SpeechService>();
  final _spellingController = Get.find<SpellingController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentWord = Get.arguments;
      if (currentWord != null) {
        _wordController.updateCurrentWord(newWord: currentWord);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(UIStrings.wordReview, style: AppTextTheme.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              final currentWord = _wordController.currentWord;
              if (currentWord == null) {
                return CircularProgressIndicator();
              } else {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    _cardWidget(currentWord: currentWord),
                    SizedBox(height: 20),
                    _listenButton(),
                    SizedBox(height: 20),
                    spellWidget(),
                    SizedBox(height: 20),
                    _editButton(currentWord: currentWord),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget spellWidget() {
    return Obx(() {
      final selectedChars = _spellingController.selectedChars;
      final word = _spellingController.word;
      final chars = _spellingController.chars;
      final accuracy = _spellingController.accuracy;

      return ExpansionWidget(
        onExpansionChanged: (value) {
          _spellingController.startPractice(isClosed: value);
        },
        title: UIStrings.spellingPractice,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(width: double.infinity),
              for (int i = 0; i < word.length; i++)
                InkWell(
                  onTap: () {
                    _spellingController.unselectChar(char: selectedChars[i]);
                  },
                  child: AnimatedScale(
                    scale: 1,
                    duration: Duration(milliseconds: 200),
                    child: CardWidget(
                      isHavePadding: false,
                      selectedBorderColor: _getSpellCharColor(
                        accuracy: accuracy,
                      ),
                      height: 45,
                      width: 45,
                      child: Center(
                        child: Text(
                          style: AppTextTheme.titleMedium,
                          i > selectedChars.length - 1
                              ? AppStrings.emptyChar
                              : selectedChars[i].char.toUpperCase(),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 15),
          Divider(),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(width: double.infinity),
              for (int i = 0; i < word.length; i++)
                InkWell(
                  onTap: () {
                    _spellingController.selectChar(char: chars[i]);
                  },
                  child: CardWidget(
                    isHavePadding: false,
                    height: 45,
                    width: 45,
                    child: Center(
                      child: Text(
                        style: AppTextTheme.titleMedium,
                        chars[i].char.toUpperCase(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      );
    });
  }

  Widget _editButton({required final WordModel currentWord}) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.addEditWordScreen,
        arguments: [WordScreenType.editWord, _wordController.currentWord],
      ),
      child: CardWidget(
        height: 50,
        child: Center(
          child: Text(UIStrings.edit, style: AppTextTheme.titleMedium),
        ),
      ),
    );
  }

  Widget _listenButton() {
    return InkWell(
      onTap: () {
        final name = _wordController.currentWord!.name;
        _speechService.speak(text: name);
      },
      child: CardWidget(
        height: 50,
        child: Row(
          spacing: 15,
          children: [
            Icon(Icons.mic_none_rounded),
            Text(style: AppTextTheme.titleMedium, UIStrings.listen),
          ],
        ),
      ),
    );
  }

  Widget _cardWidget({required final WordModel currentWord}) {
    return FlipCard(
      direction: FlipDirection.VERTICAL,
      speed: 250,
      front: Stack(
        children: [
          CardWidget(
            selectedBorderColor: ConstEntityColors.colors[currentWord.color],
            height: 200,
            child: Center(
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    final isPracticeMode = _spellingController.isPracticeMode;

                    if (!isPracticeMode) {
                      return Text(
                        textAlign: TextAlign.center,
                        style: AppTextTheme.displayLarge,
                        '${currentWord.name.capitalizeFirst}',
                      );
                    } else {
                      return Text(
                        textAlign: TextAlign.center,
                        style: AppTextTheme.displayLarge,
                        '${currentWord.name.capitalizeFirst?.replaceAll(RegExp(r'.'), '*')}',
                      );
                    }
                  }),
                  Text(
                    textAlign: TextAlign.center,
                    style: AppTextTheme.titleMedium,
                    ConstWordTypes.wordTypes[currentWord.type],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Icon(ConstIcons.icons[currentWord.icon]),
          ),
        ],
      ),
      back: Stack(
        children: [
          CardWidget(
            selectedBorderColor: ConstEntityColors.colors[currentWord.color],
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    style: AppTextTheme.displayMedium,
                    currentWord.meaning,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    style: AppTextTheme.titleMedium,
                    currentWord.example,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Icon(ConstIcons.icons[currentWord.icon]),
          ),
        ],
      ),
    );
  }

  Color _getSpellCharColor({required final bool? accuracy}) {
    switch (accuracy) {
      case false:
        {
          return ConstUiColors.errorColor;
        }
      case true:
        {
          return ConstUiColors.positiveColor;
        }
      default:
        {
          return ConstUiColors.thirdColor;
        }
    }
  }
}
