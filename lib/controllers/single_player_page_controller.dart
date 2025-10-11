import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/models/levels.dart';
import 'package:word_guess/models/word_model.dart';

class XSinglePlayerPageController extends GetxController {
  String selectedWord = '';
  final RxList<XWordModel> board = <XWordModel>[].obs;

  RxInt currentRow = 0.obs;
  RxInt currentCol = 0.obs;
  final carouselController = CarouselController(initialItem: 0);

  int get attempts => board.length;
  int get wordLength => selectedWord.length;
  XLetterModel get currentLetter =>
      board[currentRow.value].letters[currentCol.value];

  void replay() {
    currentCol.value = 0;
    currentRow.value = 0;
    startGame();
  }

  void addAttempt([int length = 1]) {
    final words = List.generate(length, (_) => XWordModel.generate(wordLength));
    for (var w in words) {
      for (var letter in w.letters) {
        final previousLetter =
            board[currentRow.value - 1].letters[letter.index];
        if (previousLetter.state == XLetterStates.correctPosAndExist) {
          words[words.indexOf(w)].letters[letter.index] = previousLetter;
        }
      }
    }
    board.addAll(words);

    // _placeCorrectCharsAtNextRow();
    update();
  }

  void startGame({
    String? word,
    int attempts = 3,
    XLevels level = XLevels.medium,
  }) {
    currentCol.value = 0;
    currentRow.value = 0;
    selectedWord =
        word ??
        _getRandomWord(switch (level) {
          XLevels.easy => 3,
          XLevels.medium => 4,
          XLevels.hard => 5,
          XLevels.extreme => 6,
          XLevels.legendary => 7,
        });
    board.value = List.generate(
      attempts,
      (_) => XWordModel.generate(wordLength),
    );
    update();
  }

  void onKeyTap(String key) {
    if (currentRow.value >= attempts) {
      return;
    }
    if (currentLetter.state == XLetterStates.correctPosAndExist) {
      if (currentCol.value >= wordLength - 1) {
        return;
      } else {
        currentCol.value++;
        onKeyTap(key);
        return;
      }
    } else {
      carouselController.animateToItem(currentRow.value);
      if (currentCol.value < wordLength) {
        board[currentRow.value].letters[currentCol.value] = XLetterModel(
          letter: key,
          state: XLetterStates.none,
          index: currentCol.value,
        );
        currentCol.value = (currentCol.value == wordLength - 1)
            ? currentCol.value
            : currentCol.value + 1;
      }
    }
    update();
  }

  void onSubmitPressed() {
    carouselController.animateToItem(currentRow.value);
    if (currentRow.value < attempts && _isSubmitAllowed()) {
      _validateRow(board[currentRow.value].letters);
      _placeCorrectCharsAtNextRow();
      currentRow.value++;
      currentCol.value = 0;
    }
    update();
    carouselController.animateToItem(currentRow.value);
  }

  void onBackspacePressed() {
    carouselController.animateToItem(currentRow.value);
    if (currentCol.value >= 0 && currentRow.value < attempts) {
      if (currentLetter.state == XLetterStates.correctPosAndExist) {
        currentCol.value = (currentCol.value == 0) ? 0 : currentCol.value - 1;
        onBackspacePressed();
        return;
      } else {
        board[currentRow.value].letters[currentCol.value] = XLetterModel(
          letter: '',
          state: XLetterStates.empty,
          index: currentCol.value,
        );
        currentCol.value = (currentCol.value == 0) ? 0 : currentCol.value - 1;
      }
    }
    update();
  }

  bool _isSubmitAllowed() {
    final noEmptyCell = board[currentRow.value].letters.every(
      (letter) => letter.state != XLetterStates.empty,
    );
    if (noEmptyCell && currentRow.value < attempts) {
      return true;
    } else {
      return false;
    }
  }

  List<XLetterModel> _validateRow(List<XLetterModel> letters) {
    final List<XLetterModel> modified = [];
    for (var element in letters) {
      if (selectedWord.contains(element.letter)) {
        element.state = XLetterStates.exist;
      }
      if (selectedWord[element.index] == element.letter) {
        element.state = XLetterStates.correctPosAndExist;
      }
      if (!selectedWord.contains(element.letter)) {
        element.state = XLetterStates.allWrong;
      }
    }
    return modified;
  }

  String _getRandomWord(int length) {
    // int index = Random.secure().nextInt(arabicWords6.length) - 1;
    arabicWords6.shuffle(Random.secure());

    final selected = arabicWords6.firstWhere((word) => word.length == length);

    if (selected.length == length) {
      return selected;
    } else {
      return _getRandomWord(length);
    }
  }

  @override
  void onInit() {
    super.onInit();
    startGame();
  }

  void _placeCorrectCharsAtNextRow() {
    if (board[currentRow.value].letters.every(
      (letter) => letter.state == XLetterStates.correctPosAndExist,
    )) {
      return;
    } else if (currentRow.value < attempts - 1) {
      board[currentRow.value].letters.forEach((letter) {
        if (letter.state == XLetterStates.correctPosAndExist) {
          board[currentRow.value + 1].letters[letter.index] = letter;
        }
      });
    }
  }
}

List<String> arabicWords6 = [
  'بيت',
  'باب',
  'شمس',
  'قمر',
  'نجم',
  'بحر',
  'جبل',
  'نهر',
  'شجر',
  'ورد',
  'ثمر',
  'زرع',
  'ماء',
  'نار',
  'هواء',
  'تراب',
  'ذهب',
  'فضة',
  'نحاس',
  'حديد',
  'لحم',
  'عظم',
  'جلد',
  'شعر',
  'وجه',
  'عين',
  'أذن',
  'أنف',
  'فم',
  'يد',
  'رجل',
  'رأس',
  'قلب',
  'كبد',
  'دم',
  'عسل',
  'لبن',
  'خبز',
  'ملح',
  'سكر',
  'رز',
  'دقيق',
  'زيت',
  'خل',
  'شاي',
  'قهوة',
  'تمر',
  'تين',
  'عنب',
  'رمان',
  'بصل',
  'ثوم',
  'جزر',
  'فجل',
  'خس',
  'ملفوف',
  'طماطم',
  'خيار',
  'فلفل',
  'باذنجان',
  'قلم',
  'كتاب',
  'دفتر',
  'ورق',
  'حبر',
  'ممحاة',
  'مسطرة',
  'مقص',
  'إبرة',
  'خيط',
  'مفتاح',

  'دبلوم',
  'درجة',
  'علامة',
  'نتيجة',
  'معلومات',
  'معرفة',
  'علوم',
  'أدب',
  'تاريخ',
  'جغرافيا',
  'رياضيات',
  'فيزياء',

  'هاديك',
  'صادقك',
  'مخلص',
  'حليمك',
  'رحيمك',
  'ناجحك',
  'لطيفك',
  'نظيفك',
  'قويان',
  'هادئك',
  'غاضبك',
  'صابر',
  'صامت',
  'مشرق',
  'غامض',
  'صاخب',
  'باردك',
  'مبدعك',
  'ناصح',
  'فارس',
  'جابر',
  'مالك',

  'غالبك',
  'قائدك',
  'فائزك',
  'خالدك',
  'سامي',
  'نبيهك',
  'حكيم',
  'محبوب',
  'مسرور',
  'مندهش',
  'مؤمن',
  'صادقك',
  'منشرح',
  'مجلات',
  'مناطق',
  'محافظ',
  'مكاتب',
];
