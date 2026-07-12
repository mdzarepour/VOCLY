import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/controller/word_details_controller.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/shared/widgets/spell_char_widget.dart';

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
                SliverToBoxAdapter(child: _spellWidget()),
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(child: _editButton()),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _cardWidget({required WordModel currentWord}) {
    // word card widget
    return FlipCard(
      direction: FlipDirection.VERTICAL,
      speed: 250,
      // card front
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
                    if (!controller.spellingController.isPracticeMode) {
                      // visible word name text
                      return Text(
                        textAlign: TextAlign.center,
                        style: AppTextTheme.displayLarge,
                        '${currentWord.name.capitalizeFirst}',
                      );
                    } else {
                      // hided word name text
                      return Text(
                        textAlign: TextAlign.center,
                        style: AppTextTheme.displayLarge,
                        '${currentWord.name.capitalizeFirst?.replaceAll(RegExp(r'.'), '*')}',
                      );
                    }
                  }),
                  // word type as text
                  Text(
                    textAlign: TextAlign.center,
                    style: AppTextTheme.titleMedium,
                    WordTypes.children[currentWord.type],
                  ),
                ],
              ),
            ),
          ),
          // right hand word icon
          Positioned(
            top: 20,
            right: 20,
            child: Icon(EntityIcon.children[currentWord.icon]),
          ),
        ],
      ),
      // crad back
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
                  // word meaning
                  Text(
                    textAlign: TextAlign.center,
                    style: AppTextTheme.displayMedium,
                    currentWord.meaning,
                  ),
                  // word example sentence
                  Text(
                    textAlign: TextAlign.center,
                    style: AppTextTheme.titleMedium,
                    currentWord.example,
                  ),
                ],
              ),
            ),
          ),
          // right hand icon
          Positioned(
            bottom: 20,
            right: 20,
            child: Icon(EntityIcon.children[currentWord.icon]),
          ),
        ],
      ),
    );
  }

  Widget _spellWidget() {
    return Obx(() {
      final chars = controller.spellingController.chars;
      final selectedChars = controller.spellingController.selectedChars;
      final accuracy = controller.spellingController.accuracy;
      
      // entire widget as card
      return CardWidget(
        child: Theme(
          data: Get.theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              controller.spellingController.handleAction(isPractice: value);
            },
            minTileHeight: 50,
            showTrailingIcon: false,
            splashColor: Colors.transparent,
            title: Center(
              child: Text(
                UIStrings.spellingPractice,
                style: AppTextTheme.titleMedium,
              ),
            ),
            children: [
              // selected chars view
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(width: double.infinity),
                  for (int i = 0; i < chars.length; i++)
                    // char widget
                    SpellCharWidget(
                      accuracy: accuracy,
                      char: i >= selectedChars.length
                          ? AppStrings.emptyChar
                          : selectedChars[i].char.toUpperCase(),
                      onTap: () {
                        if (i > selectedChars.length) {
                          null;
                        } else {
                          controller.spellingController.unselectChar(
                            char: selectedChars[i],
                            selectedIndex: i,
                          );
                        }
                      },
                    ),
                ],
              ),
              SizedBox(height: 15),
              Divider(),
              // chars keyboard
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(width: double.infinity),
                  for (int i = 0; i < chars.length; i++)
                    // char widget
                    SpellCharWidget(
                      accuracy: accuracy,
                      char: chars[i].char.toUpperCase(),
                      onTap: () {
                        controller.spellingController.selectChar(
                          char: chars[i],
                        );
                      },
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
}
