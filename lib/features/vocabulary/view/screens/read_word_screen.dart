import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/controller/word_details_controller.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

class ReadWordScreen extends GetView<WordDetailsController> {
  const ReadWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(UIStrings.wordReview, style: AppTextTheme.titleMedium),
      ),
      body: SafeArea(
        child: Obx(() {
          final currentWord = controller.word;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: _cardWidget(currentWord: currentWord!),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(child: _listenButton()),
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                //TODO remove context passing
                SliverToBoxAdapter(child: _spellWidget(context: context)),
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(child: _editButton()),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _spellWidget({required BuildContext context}) {
    return Obx(() {
      final selectedChars = controller.spellingController.selectedChars;
      final word = controller.spellingController.wordName;
      final chars = controller.spellingController.chars;
      final accuracy = controller.spellingController.accuracy;

      return CardWidget(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              controller.spellingController.handleAction(isPractice: value);
            },
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
                      onTap: i > selectedChars.length
                          ? null
                          : () => controller.spellingController.unselectChar(
                              char: selectedChars[i],
                              selectedIndex: i,
                            ),
                      child: CardWidget(
                        height: 45,
                        width: 45,
                        isHavePadding: false,
                        selectedBorderColor: _getSpellCharColor(
                          accuracy: accuracy,
                        ),
                        child: Center(
                          child: Text(
                            i >= selectedChars.length
                                ? AppStrings.emptyChar
                                : selectedChars[i].char.toUpperCase(),
                            style: AppTextTheme.titleMedium,
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
                  for (int i = 0; i < chars.length; i++)
                    InkWell(
                      onTap: () {
                        controller.spellingController.selectChar(
                          char: chars[i],
                        );
                      },
                      child: CardWidget(
                        selectedBorderColor: _getSpellCharColor(
                          accuracy: accuracy,
                        ),
                        isHavePadding: false,
                        height: 45,
                        width: 45,
                        child: Center(
                          child: Text(
                            chars[i].char.toUpperCase(),
                            style: AppTextTheme.titleMedium,
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

  Widget _editButton() {
    return InkWell(
      onTap: () => controller.goToAddEditWordScreen(),
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
      onTap: () => controller.listenToWord(),
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

  Widget _cardWidget({required WordModel currentWord}) {
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
                    final isPracticeMode =
                        controller.spellingController.isPracticeMode;
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
