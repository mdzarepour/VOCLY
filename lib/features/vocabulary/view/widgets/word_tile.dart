import 'package:flutter/material.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';

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
              height: 68,
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
                          WordTypes.children[type!],
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: EntityColor.children[color!],
                  ),
                ],
              ),
            )
          : CardWidget(
              height: 68,
              selectedBorderColor: selectedBorderColor,
              child: Row(
                spacing: 15,
                children: [
                  Icon(EntityIcon.children[icon!]),
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
                    backgroundColor: EntityColor.children[color!],
                    radius: 5,
                  ),
                ],
              ),
            ),
    );
  }
}
