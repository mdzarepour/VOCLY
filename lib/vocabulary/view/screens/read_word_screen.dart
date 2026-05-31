import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/common/widgets/expansion_widget.dart';
import 'package:vocly/core/constants/const_colors.dart';
import 'package:vocly/core/constants/const_strings.dart';
import 'package:vocly/core/enums/enums.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/vocabulary/controller/spelling_controller.dart';
import 'package:vocly/vocabulary/controller/word_controller.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

class ReadWordScreen extends StatefulWidget {
  const ReadWordScreen({super.key});

  @override
  State<ReadWordScreen> createState() => _ReadWordScreenState();
}

class _ReadWordScreenState extends State<ReadWordScreen> {
  final _wordController = Get.find<WordController>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentWord = Get.arguments;
      if (currentWord != null) {
        _wordController.updateCurrentItem(freshModel: currentWord);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Word review', style: AppTextTheme.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                _cardWidget(),
                SizedBox(height: 20),
                _listenButton(),
                SizedBox(height: 20),
                spellWidget(),
                SizedBox(height: 20),
                _editButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget spellWidget() {
    return GetBuilder<SpellingController>(
      builder: (controller) {
        final selectedChars = controller.selectedChars;
        final chars = controller.chars;
        final word = controller.word;
        return ExpansionWidget(
          onExpansionChanged: (value) {
            controller.startSpellingPractice(isClosed: value);
          },
          title: 'Spelling practice',
          children: [
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(width: double.infinity),
                  for (int i = 0; i < word.length; i++)
                    InkWell(
                      onTap: () {
                        controller.unselectChar(char: selectedChars[i]);
                      },
                      child: AnimatedScale(
                        scale: 1,
                        duration: Duration(milliseconds: 200),
                        child: CardWidget(
                          isHavePadding: false,
                          selectedBorderColor: _getSpellCharColor(
                            accuracy: controller.accuracy,
                          ),
                          height: 45,
                          width: 45,
                          child: Center(
                            child: Text(
                              style: AppTextTheme.titleMedium,
                              i > selectedChars.length - 1
                                  ? ''
                                  : selectedChars[i].char,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(width: double.infinity),
                  for (int i = 0; i < word.length; i++)
                    InkWell(
                      onTap: () {
                        controller.selectChar(char: chars[i]);
                      },
                      child: CardWidget(
                        isHavePadding: false,
                        height: 45,
                        width: 45,
                        child: Center(
                          child: Text(
                            style: AppTextTheme.titleMedium,
                            chars[i].char,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _editButton() {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.addEditWordScreen,
        arguments: [WordScreenType.edit, _wordController.currentItem],
      ),
      child: CardWidget(
        height: 50,
        child: Center(child: Text('Edit', style: AppTextTheme.titleMedium)),
      ),
    );
  }

  Widget _listenButton() {
    return InkWell(
      onTap: () async {},
      child: CardWidget(
        height: 50,
        child: Row(
          spacing: 15,
          children: [
            Icon(Icons.mic_none_rounded),
            Text(style: AppTextTheme.titleMedium, 'Listen'),
          ],
        ),
      ),
    );
  }

  Widget _cardWidget() {
    return GetBuilder<WordController>(
      builder: (wordController) {
        final WordModel? currentWord = wordController.currentItem;
        if (currentWord == null) {
          return CircularProgressIndicator();
        } else {
          return FlipCard(
            direction: FlipDirection.VERTICAL,
            speed: 250,
            front: Stack(
              children: [
                CardWidget(
                  height: 200,
                  child: Center(
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder<SpellingController>(
                          builder: (spellController) {
                            final isPracticeMode = spellController.isPracticeMode ;
                            if(!isPracticeMode){
                              return  Text(
                                  textAlign: TextAlign.center,
                                  style: AppTextTheme.displayLarge,
                                  '${currentWord.name!.capitalizeFirst}',
                                );
                            }else{
                              return  Text(
                                  textAlign: TextAlign.center,
                                  style: AppTextTheme.displayLarge,
                                  '${currentWord.name!.capitalizeFirst?.replaceAll(RegExp(r'.'), '•')}',
                                );
                            }
                          }
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          style: AppTextTheme.titleMedium,
                          ConstWordTypes.wordTypes[currentWord.type!],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: ConstWordColors.colors[currentWord.color!],
                  ),
                ),
              ],
            ),
            back: Stack(
              children: [
                CardWidget(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          style: AppTextTheme.displayMedium,
                          currentWord.meaning!,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          style: AppTextTheme.titleMedium,
                          currentWord.example!,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: ConstWordColors.colors[currentWord.color!],
                  ),
                ),
              ],
            ),
          );
        }
      },
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
