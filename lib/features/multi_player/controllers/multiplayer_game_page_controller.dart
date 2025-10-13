import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/multiplayer_options_page_controller.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/storage_service.dart';

class MultiplayerGamePageController extends GetxController {
  String get _opponentWord =>
      roomInfo.room?.creator.clientId == storage.playerId
      ? roomInfo.room?.jonerWord ?? ""
      : roomInfo.room?.creatorWord ?? "";

  String get _myWord => roomInfo.room?.creator.clientId != storage.playerId
      ? roomInfo.room?.jonerWord ?? ""
      : roomInfo.room?.creatorWord ?? "";

  String get opponentName => roomInfo.room?.creator.clientId == storage.playerId
      ? roomInfo.room?.joiner?.name ?? ""
      : roomInfo.room?.creator.name ?? "";

  final RxList<XWordModel> board = <XWordModel>[].obs;
  final opponentGuessWord = XWordModel.fromString('').obs;
  final opponentGuess = ''.obs;
  RxInt currentRow = 0.obs;
  RxInt currentCol = 0.obs;
  final carouselController = CarouselController(initialItem: 0);

  int get attempts => roomInfo.room?.maxAttempts ?? 0;
  int get wordLength => roomInfo.room?.wordLength ?? 0;
  XLetterModel get _currentLetter =>
      board[currentRow.value].letters[currentCol.value];
  final storage = Get.find<StorageService>();
  final roomInfo = Get.find<XMultiplayerOptionsPageController>();
  final myTurn = false.obs;
  final hub = Get.find<XHubServices>().connection;

  void startGame() {
    currentCol.value = 0;
    currentRow.value = 0;
    board.value = List.generate(
      attempts,
      (_) => XWordModel.generate(wordLength),
    );

    update();
  }

  void _sendGuess(String word) {
    hub.invoke('SendMyGuess', args: <Object>[storage.playerId!, word]);
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

  void checkWinCase(XWordModel word, bool forMe) {
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

  List<XLetterModel> _validateRow(String word, List<XLetterModel> letters) {
    final List<XLetterModel> modified = [];
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

  @override
  void onInit() {
    startGame();
    opponentGuessWord.value = XWordModel.generate(
      roomInfo.room?.wordLength ?? 0,
    );
    hub.on('ReceiveOpponentGuess', _handelReceiveOpponentGuess);
    super.onInit();
  }

  @override
  void dispose() {
    hub.off('ReceiveOpponentGuess');

    super.dispose();
  }

  void _handelReceiveOpponentGuess(List? arguments) {
    arguments = arguments as List;
    final (id, guess) = (arguments[0] as String, arguments[1] as String);

    opponentGuess.value = guess;
    opponentGuessWord.value = XWordModel.fromString(guess);
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
