import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget buildSelectNumberWidgetImp(
  void Function(int selected) onNumberSelected, {
  required int start,
  required int end,
  String? label,
  int defaultNumber = 6,
}) {
  int _selectedNumber = start;
  return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (label != null) Text(label, style: Get.textTheme.bodyMedium),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 70),
          child: ListWheelScrollView.useDelegate(
            itemExtent: 30,
            diameterRatio: 2,
            perspective: 0.009,
            overAndUnderCenterOpacity: 0.5,
            physics: FixedExtentScrollPhysics(),
            onSelectedItemChanged: (value) {
              _selectedNumber = value + start;
              onNumberSelected(_selectedNumber);
            },
            childDelegate: ListWheelChildListDelegate(
              children: List.generate(end - start + 1, (index) {
                return FittedBox(
                  child: Text(
                    (index + start).toString(),
                    style: Get.textTheme.titleMedium,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    ),
  );
}
