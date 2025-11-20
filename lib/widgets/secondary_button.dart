import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
    this.content, {
    super.key,
    this.icon,
    this.trailingIcon,
    required this.onPressed,
    this.enabled = true,
  });
  final String content;
  final bool enabled;
  final IconData? icon;
  final IconData? trailingIcon;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey[800],
          elevation: 2,
          // shadowColor: XAppColorsLight.highlight,
        ),

        onPressed: enabled ? onPressed : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, size: 30),
              if (icon != null) SizedBox(width: 5),
              FittedBox(child: Text(content, style: Get.textTheme.titleSmall)),
              if (trailingIcon != null) SizedBox(width: 5),
              if (trailingIcon != null) Icon(trailingIcon, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
