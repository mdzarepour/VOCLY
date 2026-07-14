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
          // small word tile
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
                        const SizedBox(width: double.infinity),
                        // word name text
                        Text(
                          name!,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleMedium,
                        ),
                        // word type as text
                        Text(
                          WordTypes.children[type!],
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  // right hand word color
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: EntityColor.children[color!],
                  ),
                ],
              ),
            )
          // big word tile
          : CardWidget(
              height: 68,
              selectedBorderColor: selectedBorderColor,
              child: Row(
                spacing: 15,
                children: [
                  // left hand word icon
                  Icon(EntityIcon.children[icon!]),
                  Expanded(
                    flex: 8,
                    child: Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // word name text
                        Text(
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleMedium,
                          name!,
                        ),
                        // word meaning text
                        Text(
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.titleSmall,
                          meaning!,
                        ),
                      ],
                    ),
                  ),
                  // right hand word color
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
