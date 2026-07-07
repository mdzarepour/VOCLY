import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:flutter/material.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';

class ExpansionWidget extends StatelessWidget {
  final String? title;
  final int? selectedChildIndex;
  final ExpantionWidgetType? type;
  final List<dynamic>? children;
  final void Function(int i)? onChildTap;

  const ExpansionWidget({
    super.key,
    this.onChildTap,
    this.selectedChildIndex,
    this.title,
    this.type,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
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
              title ?? AppStrings.emptyChar,
              style: AppTextTheme.titleMedium,
            ),
          ),
          children: [
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                for (int i = 0; i < children!.length; i++)
                  InkWell(
                    onTap: () => onChildTap.call(i),
                    child: Container(
                      height: 40,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ConstUiColors.backgroundColor2,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: i == selectedChildIndex
                            ? ConstUiColors.backgroundColor2
                            : ConstUiColors.forthColor,
                      ),
                      child: getDynamicChildWidget(i: i),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDynamicChildWidget({required int i}) {
    switch (type) {
      case ExpantionWidgetType.entityIcon:
        {
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: ConstUiColors.backgroundColor2),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: i == selectedChildIndex
                  ? ConstUiColors.backgroundColor2
                  : ConstUiColors.forthColor,
            ),
            child: Icon(children![i] as IconData?),
          );
        }
      case ExpantionWidgetType.entityColor:
        {
          return Container(
            width: 40,
            height: 40,
            padding: i == selectedChildIndex
                ? EdgeInsets.all(15)
                : EdgeInsets.all(100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: children![i] as Color,
            ),
            child: CircleAvatar(backgroundColor: ConstUiColors.backgroundColor),
          );
        }
      default:
        {
          return Center(
            child: Text(
              children![i] as String,
              style: AppTextTheme.headlineSmall,
            ),
          );
        }
    }
  }
}
