import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';

class DialogService extends GetxService {
  Future<bool?> showDialog({
    required final String title,
    required final String content,
    required final String confirmTitle,
  }) async {
    final bool result = await Get.dialog(
      barrierColor: ConstUiColors.backgroundColor,
      transitionCurve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 100),
      useSafeArea: true,
      _DialogWidget(title: title, content: content, confirmTitle: confirmTitle),
    );
    return result;
  }
}

class _DialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final String confirmTitle;

  const _DialogWidget({
    required this.title,
    required this.content,
    required this.confirmTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(color: ConstUiColors.backgroundColor2),
      ),
      backgroundColor: ConstUiColors.forthColor,
      title: Text(title, style: AppTextTheme.titleLarge),
      content: Text(content, style: AppTextTheme.titleMedium),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Get.back(result: false),
                child: CardWidget(
                  height: 60,
                  child: Center(
                    child: Text(
                      UIStrings.cancel,
                      style: AppTextTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () => Get.back(result: true),
                child: CardWidget(
                  selectedBorderColor: ConstUiColors.thirdColor,
                  height: 60,
                  child: Center(
                    child: Text(confirmTitle, style: AppTextTheme.titleMedium),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
