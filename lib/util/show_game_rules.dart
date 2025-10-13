import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/widgets/word_widget.dart';

void showGameRules() {
  final textStyle = Get.textTheme.bodyMedium;
  final double dividerHeight = 15;
  Get.defaultDialog(
    title: XHomePageStrings.gameRoles.tr,
    titleStyle: Get.textTheme.titleMedium,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'خمِّن الكلمة  في  8  محاولات. سيتغيّر لون المربعات بعد كل محاولة لإظهار مدى قرب تخمينك من الكلمة',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        Divider(height: dividerHeight),
        XWordWidget(word: _getWordForInfo(XLetterStates.correct)),
        Text(
          'حرف الميم موجود و في مكانة الصحيح',
          style: textStyle,
          textAlign: TextAlign.center,
        ),

        Divider(height: dividerHeight),
        XWordWidget(word: _getWordForInfo(XLetterStates.present)),
        Text(
          'حرف الكاف موجود لكن في مكانه الخطأ',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        Divider(height: dividerHeight),
        XWordWidget(word: _getWordForInfo(XLetterStates.absent)),
        FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'الكلمة لا تحتوي على أي حرف من هذه الحروف',
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ]
    ),
    confirm: ElevatedButton.icon(
      label: Text('تمام'),
      icon: Icon(Icons.thumb_up),
      onPressed: Get.back,
    ),
  );
}

XWordModel _getWordForInfo(String state) {
  XWordModel word = XWordModel.fromString('يأكل');
  if (state == XLetterStates.absent) {
    for (var l in word.letters) {
      l.state = XLetterStates.absent;
    }
    return word;
  } else if (state == XLetterStates.correct) {
    word = XWordModel.fromString('محمد');
    word.letters[2].state = XLetterStates.correct;
    return word;
  } else if (state == XLetterStates.present) {
    word = XWordModel.fromString('اكرم');
    word.letters[1].state = XLetterStates.present;
    return word;
  }
  return word;
}
