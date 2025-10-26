import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/single_player/models/letter_model.dart';
import 'package:word_guess/features/single_player/models/letter_states.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/util/helpers/helper.dart';

class XSinglePlayerPageController extends GetxController {
  String _selectedWord = '';
  //Vars
  final RxList<WordModel> board = <WordModel>[].obs;
  int _currentRow = 0;
  int _currentCol = 0;
  final scrollController = ScrollController(keepScrollOffset: true);
  final double _letterHeight = 64;
  // Getters
  int get attempts => board.length;
  int get wordLength => _selectedWord.length;
  LetterModel get currentLetter => board[_currentRow].letters[_currentCol];
  final _storage = Get.find<StorageService>();
  //todo: handel when attempts reached
  //todo: display the word when lose
  // public methods
  void replay() {
    _currentCol = 0;
    _currentRow = 0;
    startGame();
  }

  void addAttempt([int length = 1]) {
    final words = List.generate(length, (_) => WordModel.generate(wordLength));
    for (var w in words) {
      for (var letter in w.letters) {
        final previousLetter = board[_currentRow - 1].letters[letter.index];
        if (previousLetter.state == XLetterStates.correct) {
          words[words.indexOf(w)].letters[letter.index] = previousLetter;
        }
      }
    }
    board.addAll(words);
    update();
  }

  void startGame({String? word, int attempts = 3, int level = 3}) {
    _currentCol = 0;
    _currentRow = 0;
    _selectedWord = word ?? Helper.getRandomWord(2 + level);
    board.value = List.generate(
      attempts,
      (_) => WordModel.generate(wordLength),
    );
    update();
  }

  void onKeyTap(String key) {
    _animateListView();
    if (_currentRow >= attempts) {
      return;
    }
    if (_currentCol < wordLength) {
      if (currentLetter.state == XLetterStates.correct) {
        _currentCol++;
        onKeyTap(key);
        return;
      } else {
        board[_currentRow].letters[_currentCol] = LetterModel(
          letter: key,
          state: XLetterStates.none,
          index: _currentCol,
        );
        update();
        _currentCol++;
      }
    } else {
      return;
    }
  }

  void onSubmitPressed() {
    _animateListView();
    if (_currentRow < attempts && _isSubmitAllowed()) {
      _validateRow(board[_currentRow].letters);
      _placeCorrectCharsAtNextRow();
      final isWinCase = (board[_currentRow].letters.every(
        (l) => l.state == XLetterStates.correct,
      ));
      if (isWinCase) {
        _storage.increasePlayedCount();
        _storage.increaseWinCount();
        _showWinDialog();
      }
      _currentRow++;
      _currentCol = 0;
      update();
    }
    if (_currentRow >= attempts) {
      _storage.increasePlayedCount();

      _showLoseDialog();
    }
    _animateListView();
  }

  void onBackspacePressed() {
    _animateListView();

    if (_currentCol > 0 && _currentRow < attempts) {
      final letterToDelete = board[_currentRow].letters[_currentCol - 1];
      if (letterToDelete.state == XLetterStates.correct) {
        _currentCol = (_currentCol == 1) ? 1 : _currentCol - 1;
        if (_currentCol > 1) {
          onBackspacePressed();
        }
        return;
      } else {
        board[_currentRow].letters[_currentCol - 1] = LetterModel(
          letter: '',
          state: XLetterStates.empty,
          index: _currentCol - 1,
        );
        update();
        _currentCol = (_currentCol == 0) ? 0 : _currentCol - 1;
      }
    }
  }

  // overrides
  @override
  void onInit() {
    super.onInit();
    startGame();
  }

  // private methods
  bool _isSubmitAllowed() {
    final noEmptyCell = board[_currentRow].letters.every(
      (letter) => letter.state != XLetterStates.empty,
    );
    if (noEmptyCell && _currentRow < attempts) {
      return true;
    } else {
      return false;
    }
  }

  List<LetterModel> _validateRow(List<LetterModel> letters) {
    final List<LetterModel> modified = [];
    for (var element in letters) {
      if (_selectedWord.contains(element.letter)) {
        element.state = XLetterStates.present;
      }
      if (_selectedWord[element.index] == element.letter) {
        element.state = XLetterStates.correct;
      }
      if (!_selectedWord.contains(element.letter)) {
        element.state = XLetterStates.absent;
      }
    }
    return modified;
  }

  void _placeCorrectCharsAtNextRow() {
    if (board[_currentRow].letters.every(
      (letter) => letter.state == XLetterStates.correct,
    )) {
      return;
    } else if (_currentRow < attempts - 1) {
      for (var letter in board[_currentRow].letters) {
        if (letter.state == XLetterStates.correct) {
          board[_currentRow + 1].letters[letter.index] = letter;
        }
      }
    }
  }

  bool canPop = false;
  _animateListView() {
    if (_currentRow > 7) {
      scrollController.animateTo(
        _letterHeight * (_currentRow - 7).toDouble(),
        curve: Curves.easeInOut,
        duration: 0.2.seconds.abs(),
      );
    }
  }

  _showLoseDialog() {
    Helper.showDialog(
      '😆 خاسر 😆',

      children: [
        Text('كلمتك كانت', style: Get.textTheme.titleSmall),
        Text(_selectedWord, style: Get.textTheme.displayLarge),
      ],

      confirmText: 'موافق',
      onConfirm: () {
        canPop = true;
        Get.back(closeOverlays: true);
      },
    );
  }

  _showWinDialog() {
    Helper.showDialog(
      '🎉 فائز  🎉',
      children: [
        Text(
          'مبروك الفوز\nالان سيتم تحويلك لصفحة تحديد المستوى\nحاول تختار مستوى اصعب',
          textAlign: TextAlign.center,
        ),
      ],
      confirmText: 'موافق',
      onConfirm: () {
        Get.back(closeOverlays: true);
      },
    );
  }
}
