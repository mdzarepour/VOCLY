import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/controller/word_crud_controller.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/widgets/expansion_widget.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/speech_service.dart';
import 'package:vocly/shared/controllers/spelling_controller.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

class ReadWordScreen extends StatefulWidget {
  const ReadWordScreen({super.key});

  @override
  State<ReadWordScreen> createState() => _ReadWordScreenState();
}

class _ReadWordScreenState extends State<ReadWordScreen> {
  final _wordController = Get.find<WordCrudController>();
  final _speechService = Get.find<SpeechService>();
  final _spellingController = Get.find<SpellingController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentWord = Get.arguments;
      if (currentWord != null) {
        //  _wordController.updateCurrentWord(newWord: currentWord);
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
        child: Obx(() {
          final currentWord = _wordController.currentWord;
          if (currentWord == null) {
            return SpinKitThreeInOut(size: 15, color: ConstUiColors.thirdColor);
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: _cardWidget(currentWord: currentWord),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: _listenButton()),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: _spellWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: _editButton(currentWord: currentWord),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _spellWidget() {
    return Obx(() {
      final selectedChars = _spellingController.selectedChars;
      final word = _spellingController.word;
      final chars = _spellingController.chars;
      final accuracy = _spellingController.accuracy;

      return CardWidget(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            dense: true,
            minTileHeight: 50,
            showTrailingIcon: false,
            splashColor: Colors.transparent,
            childrenPadding: EdgeInsets.only(bottom: 30),
            title: Center(
              child: Text(
                UIStrings.spellingPractice,
                style: AppTextTheme.titleMedium,
              ),
            ),
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(width: double.infinity),
                  for (int i = 0; i < word.length; i++)
                    InkWell(
                      onTap: () {
                        _spellingController.unselectChar(
                          char: selectedChars[i],
                        );
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
          ),
        ),
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
            selectedBorderColor: EntityColor.children[currentWord.color],
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
                    WordTypes.children[currentWord.type],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Icon(EntityIcon.children[currentWord.icon]),
          ),
        ],
      ),
      back: Stack(
        children: [
          CardWidget(
            selectedBorderColor: EntityColor.children[currentWord.color],
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
            child: Icon(EntityIcon.children[currentWord.icon]),
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
