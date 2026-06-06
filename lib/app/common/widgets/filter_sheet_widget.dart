import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/app/common/constants/const_colors.dart';
import 'package:vocly/app/common/theme/app_text_theme.dart';
import 'package:vocly/app/core/enums/enums.dart';

class FilterSheetWidget extends StatelessWidget {
  final void Function(int) onChanged;
  final bool Function(int) isSelected;
  final List filterItems;
  final FilterType type;

  const FilterSheetWidget({
    super.key,
    required this.onChanged,
    required this.isSelected,
    required this.filterItems,
    required this.type,
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
              for (int i = 0; i < filterItems.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // dynamic left child -->
                      getFilterItemWidget(filterContent: filterItems[i]),
                      // check box -->
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
                            value: isSelected(i),
                            onChanged: (value) => onChanged.call(i),
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

  Widget getFilterItemWidget({required final dynamic filterContent}) {
    switch (type) {
      case FilterType.color:
        {
          return CircleAvatar(backgroundColor: filterContent, radius: 10);
        }
      case FilterType.type:
        {
          return Text(style: AppTextTheme.titleMedium, filterContent as String);
        }
      case FilterType.icon:
        {
          return Icon(filterContent as IconData);
        }
      case FilterType.level:
        {
          return Text(style: AppTextTheme.titleMedium, filterContent as String);
        }
    }
  }
}
