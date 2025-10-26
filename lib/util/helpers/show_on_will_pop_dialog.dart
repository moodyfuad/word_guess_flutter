import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/theme/app_colors.dart';

Future<bool> showOnWillPopDialogImp(
  String title,
  List<String> contentList, {
  Function(bool val)? onResult,
}) async {
  bool val = false;
  final d = await Get.defaultDialog<bool>(
    backgroundColor: XAppColorsLight.bg,
    title: title,
    titleStyle: Get.textTheme.displayMedium,
    content: ConstrainedBox(
      constraints: BoxConstraints(minWidth: Get.width * .9),
      child: Column(
        children: [
          ...contentList.map((content) {
            return Text(content, style: Get.textTheme.bodyLarge);
          }),
          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),

                  onPressed: () {
                    val = true;
                    Get.back(result: true);
                  },
                  child: Text('غادر', style: Get.textTheme.titleSmall),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    val = false;
                    Get.back(result: false);
                  },
                  child: Text('الغاء', style: Get.textTheme.titleSmall),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  onResult?.call(val);
  return d ?? val;
}
