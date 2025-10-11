import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:word_guess/models/word_model.dart';
import 'package:word_guess/widgets/word_widget.dart';

void showGameRules() {
    final textStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
    final double dividerHeight = 15;
    Get.defaultDialog(
      title: 'قواعد اللعبة',
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
          XWordWidget(word: _getWordForInfo(XLetterStates.correctPosAndExist)),
          Text(
            'حرف الميم موجود و في مكانة الصحيح',
            style: textStyle,
            textAlign: TextAlign.center,
          ),

          Divider(height: dividerHeight),
          XWordWidget(word: _getWordForInfo(XLetterStates.exist)),
          Text(
            'حرف الكاف موجود لكن في مكانه الخطأ',
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          Divider(height: dividerHeight),
          XWordWidget(word: _getWordForInfo(XLetterStates.allWrong)),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'الكلمة لا تحتوي على أي حرف من هذه الحروف',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      confirm: ElevatedButton.icon(label: Text('تمام'), icon:Icon(Icons.done), onPressed: Get.back),
    );
  }

  XWordModel _getWordForInfo(XLetterStates state) {
    XWordModel word = XWordModel.fromString('يأكل');
    if (state == XLetterStates.allWrong) {
      word.letters.forEach((l) => l.state = XLetterStates.allWrong);
      return word;
    } else if (state == XLetterStates.correctPosAndExist) {
      word = XWordModel.fromString('محمد');
      word.letters[2].state = XLetterStates.correctPosAndExist;
      return word;
    } else if (state == XLetterStates.exist) {
      word = XWordModel.fromString('اكرم');
      word.letters[1].state = XLetterStates.exist;
      return word;
    }
    return word;
  }