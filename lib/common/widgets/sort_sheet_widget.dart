import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/core/enums/enums.dart';

class SortSheetWidget extends StatelessWidget {
  final void Function(SortType) onChanged;
  final bool Function(SortType) isSelected;

  const SortSheetWidget({
    super.key,
    required this.onChanged,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        Container(
          width: 50,
          height: 3,
          decoration: BoxDecoration(color: ConstUiColors.thirdColor),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            children: [
              for (int i = 0; i < AppStrings.wordSortItems.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        style: AppTextTheme.titleMedium,
                        AppStrings.wordSortItems[i]['name'],
                      ),
                      Obx(() {
                        return SizedBox(
                          height: 20,
                          child: Checkbox(
                            side: BorderSide(
                              width: 2,
                              color: ConstUiColors.thirdColor,
                            ),
                            checkColor: ConstUiColors.thirdColor,
                            activeColor: ConstUiColors.backgroundColor,
                            value: isSelected.call(
                              AppStrings.wordSortItems[i]['type'],
                            ),
                            shape: const CircleBorder(),
                            onChanged: (value) => onChanged.call(
                              AppStrings.wordSortItems[i]['type'],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
