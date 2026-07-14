import 'package:flutter/material.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';

class BookTile extends StatelessWidget {
  final String name;
  final int icon;
  final Color color ;
  final void Function()? onLongPress;
  final void Function()? onTap;
  const BookTile({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Stack(
        children: [
          CardWidget(
            selectedBorderColor: color,
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                style: AppTextTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                name,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Icon(EntityIcon.children[icon]),
          ),
        ],
      ),
    );
  }
}
