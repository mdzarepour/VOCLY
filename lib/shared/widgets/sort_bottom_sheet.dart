import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';

class SortBottomSheet extends StatelessWidget {
  final void Function(SortType) onChanged;
  final bool Function(SortType) isSelected;

  const SortBottomSheet({
    super.key,
    required this.onChanged,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        // drag effect widget
        Container(
          width: 50,
          height: 3,
          decoration: const BoxDecoration(color: ConstUiColors.thirdColor),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            children: [
              for (int i = 0; i < SortItems.children.length; i++)
                // sort selecting widget
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // sort name
                      Text(
                        style: AppTextTheme.titleMedium,
                        SortItems.children[i]['name'],
                      ),
                      Obx(() {
                        return SizedBox(
                          height: 20,
                          child: Checkbox(
                            side: const BorderSide(
                              width: 2,
                              color: ConstUiColors.thirdColor,
                            ),
                            checkColor: ConstUiColors.thirdColor,
                            activeColor: ConstUiColors.backgroundColor,
                            shape: const CircleBorder(),

                            /// Sending sort item to ui to update checkbox state
                            value: isSelected.call(
                              SortItems.children[i]['type'],
                            ),

                            /// Sending sort item to ui to select it
                            onChanged: (value) {
                              onChanged.call(SortItems.children[i]['type']);
                            },
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
