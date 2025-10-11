import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XKeyBoardWidget extends StatelessWidget {
  XKeyBoardWidget({
    super.key,
    required this.onKeyTap,
    required this.onSummitTap,
    required this.onBackspaceTap,
  });
  final void Function(String key) onKeyTap;
  final void Function() onSummitTap;
  final void Function() onBackspaceTap;
  final List<String> letters =
      'ج ح خ ه ع غ ف ق ث ص ض ط ك م ن ت ا ل ب ي س ش د ظ ز و ة ى ر ؤ ء ئ ذ'.split(
        ' ',
      );
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 8.0,
              ),
              child: Row(
                children: [XKeyWidget('تاكيد', true, (_) => onSummitTap())],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                XKeyWidget('حذف', true, (_) => onBackspaceTap()),
                ...List.generate(
                  11,
                  (index) => XKeyWidget(letters[index], false, onKeyTap),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                ...List.generate(
                  11,
                  (index) => XKeyWidget(letters[index + 11], false, onKeyTap),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                ...List.generate(
                  11,
                  (index) => XKeyWidget(letters[index + 22], false, onKeyTap),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget XKeyWidget(String key, bool primary, void Function(String key) onTap) {
  return Expanded(
    flex: primary ? 2 : 1,
    child: GestureDetector(
      onTap: () => onTap(key),
      child: Container(
        margin: const EdgeInsets.all(1),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
          color: primary ? Colors.amberAccent : Colors.white60,
        ),
        child: Center(
          child: Text(
            key,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}
