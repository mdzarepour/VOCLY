import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';

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
              for (int i = 0; i < ConstSortItems.sortItems.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        style: AppTextTheme.titleMedium,
                        ConstSortItems.sortItems[i]['name'],
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
                              ConstSortItems.sortItems[i]['type'],
                            ),
                            shape: const CircleBorder(),
                            onChanged: (value) => onChanged.call(
                              ConstSortItems.sortItems[i]['type'],
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
