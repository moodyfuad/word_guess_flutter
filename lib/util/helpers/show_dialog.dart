import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/widgets/secondary_button.dart';

showDialogImp(
  String title, {
  required List<Widget> children,
  required String confirmText,
  required bool closeDialogOnSelection,
  void Function()? onConfirm,
  String? cancelText,
  void Function()? onCancel,
}) async {
  bool result = false;
  await Get.defaultDialog(
    titlePadding: EdgeInsets.all(16),
    contentPadding: EdgeInsets.all(16),
    title: title,
    titleStyle: Get.textTheme.titleLarge,
    backgroundColor: XAppColorsLight.bg,
    content: Column(children: children),
    confirm: SecondaryButton(
      confirmText,
      onPressed: () {
        // Get.back(result: true);
        if (closeDialogOnSelection) {
          Get.back(result: true);
        }
        result = true;
      },
    ),
    cancel: cancelText == null
        ? null
        : SecondaryButton(
            cancelText,
            onPressed: () {
              // Get.back(result: false);

              if (closeDialogOnSelection) {
                Get.back(result: true);
              }
              result = false;
            },
          ),
  );

  result ? onConfirm?.call() : onCancel?.call();
}
