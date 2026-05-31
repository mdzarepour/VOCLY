import 'package:flutter/material.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/core/constants/const_colors.dart';
import 'package:vocly/core/constants/const_icons.dart';
import 'package:vocly/core/constants/const_strings.dart';

class WordTile extends StatelessWidget {
  final bool isSmallTile;
  final int? color;
  final int? icon;
  final int? type;
  final String? name;
  final String? meaning;
  final Color? selectedBorderColor;
  final void Function()? onLongPress;
  final void Function()? onTap;

  const WordTile({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.meaning,
    required this.icon,
    required this.type,
    required this.name,
    required this.isSmallTile,
    this.selectedBorderColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: isSmallTile
          ? CardWidget(
              selectedBorderColor: selectedBorderColor,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        SizedBox(width: double.infinity),
                        Text(
                          name!,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleMedium,
                        ),
                        Text(
                          ConstWordTypes.wordTypes[type!],
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: ConstWordColors.colors[color!],
                  ),
                ],
              ),
            )
          : CardWidget(
              selectedBorderColor: selectedBorderColor,
              child: Row(
                spacing: 15,
                children: [
                  Icon(ConstIcons.icons[icon!]),
                  Expanded(
                    flex: 8,
                    child: Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleMedium,
                          name!,
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleSmall,
                          meaning!,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: ConstWordColors.colors[color!],
                    radius: 5,
                  ),
                ],
              ),
            ),
    );
  }
}
