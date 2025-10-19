import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_options_page_controller.dart';
import 'package:word_guess/features/single_player/models/letter_model.dart';
import 'package:word_guess/features/single_player/models/letter_states.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/storage_service.dart';

class MultiplayerGamePageController extends GetxController {
  String get _opponentWord => roomInfo.room?.creatorId == storage.playerId
      ? roomInfo.room?.joinerWord ?? ""
      : roomInfo.room?.creatorWord ?? "";

  String get _myWord => roomInfo.room?.creatorId != storage.playerId
      ? roomInfo.room?.joinerWord ?? ""
      : roomInfo.room?.creatorWord ?? "";

  String get opponentName => roomInfo.opponent?.name ?? "";

  final RxList<WordModel> board = <WordModel>[].obs;
  final opponentGuessWord = WordModel.fromString('').obs;
  final opponentGuess = ''.obs;
  RxInt currentRow = 0.obs;
  RxInt currentCol = 0.obs;
  final carouselController = CarouselController(initialItem: 0);

  int get attempts => roomInfo.room?.maxAttempts ?? 0;
  int get wordLength => roomInfo.room?.wordLength ?? 0;
  LetterModel get _currentLetter =>
      board[currentRow.value].letters[currentCol.value];
  final storage = Get.find<StorageService>();
  final roomInfo = Get.find<MultiplayerOptionsPageController>();
  final myTurn = false.obs;
  final hub = Get.find<HubServices>();

  void startGame() {
    currentCol.value = 0;
    currentRow.value = 0;
    board.value = List.generate(
      attempts,
      (_) => WordModel.generate(wordLength),
    );

    update();
  }

  void _sendGuess(String word) {
    hub.sendMyGuess(storage.playerId!, word);
  }

  void onKeyTap(String key) {
    if (currentRow.value >= attempts) {
      return;
    }
    if (_currentLetter.state == XLetterStates.correct) {
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
        board[currentRow.value].letters[currentCol.value] = LetterModel(
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
      _validateRow(_opponentWord, board[currentRow.value].letters);
      _placeCorrectCharsAtNextRow();
      checkWinCase(board[currentRow.value], true);
      currentRow.value++;
      currentCol.value = 0;
      //todo: send to server;
      final word = board[currentRow.value - 1].letters.fold(
        '',
        (previousValue, element) => previousValue += element.letter,
      );
      _sendGuess(word);
      update();
      carouselController.animateToItem(currentRow.value);
    }
  }

  void checkWinCase(WordModel word, bool forMe) {
    final bool win = board[currentRow.value].letters.every(
      (letter) => letter.state == XLetterStates.correct,
    );
    if (win && forMe) {
      _showWinDialog();
    } else if (win && !forMe) {
      _showLoseDialog();
    }
  }

  void onBackspacePressed() {
    carouselController.animateToItem(currentRow.value);
    if (currentCol.value >= 0 && currentRow.value < attempts) {
      if (_currentLetter.state == XLetterStates.correct) {
        currentCol.value = (currentCol.value == 0) ? 0 : currentCol.value - 1;
        onBackspacePressed();
        return;
      } else {
        board[currentRow.value].letters[currentCol.value] = LetterModel(
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

  List<LetterModel> _validateRow(String word, List<LetterModel> letters) {
    final List<LetterModel> modified = [];
    for (var element in letters) {
      if (word.contains(element.letter)) {
        element.state = XLetterStates.present;
      }
      if (word[element.index] == element.letter) {
        element.state = XLetterStates.correct;
      }
      if (!word.contains(element.letter)) {
        element.state = XLetterStates.absent;
      }
    }
    return modified;
  }

  void _placeCorrectCharsAtNextRow() {
    if (board[currentRow.value].letters.every(
      (letter) => letter.state == XLetterStates.correct,
    )) {
      return;
    } else if (currentRow.value < attempts - 1) {
      board[currentRow.value].letters.forEach((letter) {
        if (letter.state == XLetterStates.correct) {
          board[currentRow.value + 1].letters[letter.index] = letter;
        }
      });
    }
  }

  _leaveGame() {
    hub.leaveGame();
  }

  @override
  void onInit() {
    startGame();
    opponentGuessWord.value = WordModel.generate(
      roomInfo.room?.wordLength ?? 0,
    );
    hub.onReceiveOpponentGuess = _handelReceiveOpponentGuess;
    super.onInit();
  }

  @override
  void dispose() {
    _leaveGame();
    super.dispose();
  }

  @override
  void onClose() {
    _leaveGame();
    super.onClose();
  }

  void _handelReceiveOpponentGuess(String id, String guess) {
    opponentGuess.value = guess;
    opponentGuessWord.value = WordModel.fromString(guess);
    _validateRow(_myWord, opponentGuessWord.value.letters);
    update();
    checkWinCase(opponentGuessWord.value, false);
  }

  //^ Dialogs
  _showWinDialog() {
    Get.defaultDialog(
      title: '🎉 فائز',
      titleStyle: Get.textTheme.displayMedium,

      content: Text(
        'مبروك الفوز\nالان سيتم تحويلك لصفحة البداية',
        textAlign: TextAlign.center,
      ),
      onConfirm: () => Get.offAllNamed(XRoutes.home),
      onWillPop: () {
        Get.offAllNamed(XRoutes.home);
        return Future.value(true);
      },
    );
  }

  _showLoseDialog() {
    Get.defaultDialog(
      title: 'خاسر 😆',
      titleStyle: Get.textTheme.displayMedium,

      content: Text(
        'مبروك الخسارة بس عادي تقدر تتحدى مرة ثانية و تفوز\nالان سيتم تحويلك لصفحة البداية',
        textAlign: TextAlign.center,
      ),
      onConfirm: () => Get.offAllNamed(XRoutes.home),
      onWillPop: () {
        Get.offAllNamed(XRoutes.home);
        return Future.value(true);
      },
    );
  }
}
