import 'package:flutter/material.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';

class PropertySelector extends StatelessWidget {
  final String? title;
  final int? selectedChildIndex;
  final ExpantionWidgetType? type;
  final List<dynamic>? children;
  final void Function(int i)? onChildTap;

  const PropertySelector({
    super.key,
    required this.onChildTap,
    required this.selectedChildIndex,
    required this.title,
    required this.type,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // entire widget
    return CardWidget(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          dense: true,
          minTileHeight: 50,
          showTrailingIcon: false,
          splashColor: Colors.transparent,
          childrenPadding: const EdgeInsets.only(bottom: 30),
          // title
          title: Center(
            child: Text(
              title ?? AppStrings.emptyChar,
              style: AppTextTheme.titleMedium,
            ),
          ),
          // children list
          children: [
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                for (int i = 0; i < children!.length; i++)
                  InkWell(
                    /// send i to ui for changing reactive variable
                    onTap: () => onChildTap!.call(i),
                    child: getDynamicChildWidget(i: i),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDynamicChildWidget({required int i}) {
    // if icon selection
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
      // if color selection
      case ExpantionWidgetType.entityColor:
        {
          return Container(
            width: 40,
            height: 40,
            padding: i == selectedChildIndex
                ? const EdgeInsets.all(15)
                : const EdgeInsets.all(100),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: children![i] as Color,
            ),
            child: const CircleAvatar(backgroundColor: ConstUiColors.backgroundColor),
          );
        }
      // if type or level selection
      default:
        {
          return Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: ConstUiColors.backgroundColor2),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: i == selectedChildIndex
                  ? ConstUiColors.backgroundColor2
                  : ConstUiColors.forthColor,
            ),
            child: Center(
              child: Text(
                children![i] as String,
                style: AppTextTheme.headlineSmall,
              ),
            ),
          );
        }
    }
  }
}
