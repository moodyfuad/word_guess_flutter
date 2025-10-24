// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:word_guess/features/multi_player/controllers/room_controller.dart';
import 'package:word_guess/features/multi_player/dtos/send_guess_request_dto.dart';
import 'package:word_guess/features/single_player/models/letter_model.dart';
import 'package:word_guess/features/single_player/models/letter_states.dart';
import 'package:word_guess/features/single_player/models/word_model.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/services/api_service.dart';
import 'package:word_guess/services/hub_services.dart';
import 'package:word_guess/services/storage_service.dart';
import 'package:word_guess/util/helpers/helper.dart';

class MultiplayerGamePageController extends GetxController {
  String get _opponentWord => room?.creatorId == _storage.playerId
      ? room?.joinerWord ?? ""
      : room?.creatorWord ?? "";

  String get _myWord => room?.creatorId != _storage.playerId
      ? room?.joinerWord ?? ""
      : room?.creatorWord ?? "";

  String get opponentName => _options.opponent?.name ?? "";

  final RxList<WordModel> board = <WordModel>[].obs;
  final opponentGuessWord = WordModel.fromString('').obs;
  final opponentGuess = ''.obs;
  int _currentRow = 0;
  int _currentCol = 0;
  final carouselController = CarouselController(initialItem: 0);

  int get attempts => room?.maxAttempts ?? 0;
  int get wordLength => room?.wordLength ?? 0;
  LetterModel get _currentLetter => board[_currentRow].letters[_currentCol];
  final _storage = Get.find<StorageService>();
  get room => _options.room;
  // final _options = Get.find<MultiplayerOptionsPageController>();
  final _options = Get.find<RoomController>();

  final myTurn = false.obs;

  final _hub = Get.find<HubServices>();
  final _api = Get.find<ApiService>();

  void startGame() {
    _currentCol = 0;
    _currentRow = 0;
    board.value = List.generate(
      attempts,
      (_) => WordModel.generate(wordLength),
    );

    update();
  }

  void _sendGuess(String word) async {
    final request = SendGuessRequestDto(
      roomKey: room!.key,
      senderId: _storage.playerId,
      word: word,
    );
    final response = await _api.post('room/sendMyGuess', data: request.toMap());
  }

  void onKeyTap(String key) {
    if (_currentRow >= attempts) {
      return;
    }
    if (_currentCol < wordLength) {
      if (_currentLetter.state == XLetterStates.correct) {
        _currentCol++;
        onKeyTap(key);
        return;
      } else {
        carouselController.animateToItem(_currentRow);
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
    carouselController.animateToItem(_currentRow);
    if (_currentRow < attempts && _isSubmitAllowed()) {
      _validateRow(_opponentWord, board[_currentRow].letters);
      _placeCorrectCharsAtNextRow();
      _checkWinCase(board[_currentRow], true);

      // send to server;
      final word = board[_currentRow].letters.fold(
        '',
        (previousValue, element) => previousValue += element.letter,
      );
      _sendGuess(word);
      _currentRow++;
      _currentCol = 0;
      update();
    }
    if (_currentRow >= attempts) {
      // todo : if the opponent is the same as me add new row to each one
      _storage.increasePlayedCount();
      _showLoseDialog();
    }
    carouselController.animateToItem(_currentRow);
  }

  void _checkWinCase(WordModel word, bool forMe) {
    final bool win = word.letters.every(
      (letter) => letter.state == XLetterStates.correct,
    );
    if (win && forMe) {
      _storage.increasePlayedCount();
      _storage.increaseWinCount();
      _showWinDialog();
      _sendPlayerScore();
    } else if (win && !forMe) {
      _storage.increasePlayedCount();
      _sendPlayerScore();
      _showLoseDialog();
    }
  }

  void onBackspacePressed() {
    carouselController.animateToItem(_currentRow);

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

  _leaveGame() async {
    await _api.post(
      'room/leaveGame',
      data: {'roomKey': room?.key, 'playerId': _storage.playerId},
    );
  }

  handelPop() async {
    final d = await Helper.showOnWillPopDialog('تنبيه', [
      'سيتم احتساب النتيجة كخسارة',
      'هل ترغب في مغادرة الغرفة ؟',
    ], onResult: (val) {});

    if (d) {
      //todo: update the score
      _storage.increasePlayedCount();
      await _leaveGame();
      //todo: send leave game to the opponent
      Get.until(
        (route) => ![
          XRoutes.multiplayerGame,
          XRoutes.selectWord,
          // XRoutes.multiplayerOptions,
        ].contains(Get.currentRoute),
      );
    }
  }

  @override
  void onInit() {
    startGame();
    opponentGuessWord.value = WordModel.generate(room?.wordLength ?? 0);
    _hub.onReceiveOpponentGuess = _handelReceiveOpponentGuess;
    _hub.onOpponentLeftGame = _handleOpponentLeftGame;
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
    _checkWinCase(opponentGuessWord.value, false);
    update();
  }

  _sendPlayerScore() {
    // todo : add playedCount,winCount
    // _api.post('player/score', didWin)
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
      onConfirm: () {
        Get.until(
          (route) => ![
            XRoutes.multiplayerGame,
            XRoutes.selectWord,
            // XRoutes.multiplayerOptions,
          ].contains(Get.currentRoute),
        );
      },

      onWillPop: () {
        Get.until(
          (route) => ![
            XRoutes.multiplayerGame,
            XRoutes.selectWord,
            // XRoutes.multiplayerOptions,
          ].contains(Get.currentRoute),
        );
        return Future.value(true);
      },
    );
  }

  _showLoseDialog() {
    Get.defaultDialog(
      title: '😆 خاسر 😆',
      titleStyle: Get.textTheme.displayMedium,

      content: Column(
        children: [
          Text(
            'مبروك الخسارة بس عادي تقدر تتحدى مرة ثانية و تفوز\nالان سيتم تحويلك لصفحة البداية',
            textAlign: TextAlign.center,
          ),
          Text('كلمة $opponentName كانت', textAlign: TextAlign.center),
          Text(
            _opponentWord,
            textAlign: TextAlign.center,
            style: Get.textTheme.displayLarge,
          ),
        ],
      ),
      onConfirm: () {
        Get.until(
          (route) => ![
            XRoutes.multiplayerGame,
            XRoutes.selectWord,
            // XRoutes.multiplayerOptions,
          ].contains(Get.currentRoute),
        );
      },
      onWillPop: () {
        Get.until(
          (route) => ![
            XRoutes.multiplayerGame,
            XRoutes.selectWord,
            // XRoutes.multiplayerOptions,
          ].contains(Get.currentRoute),
        );
        return Future.value(true);
      },
    );
  }

  void _handleOpponentLeftGame() {
    Get.snackbar(
      'انقطع الاتصال عند الخصم',
      'تم احتساب فوزك بشكل تلقائي',
      barBlur: 0.1,
      overlayBlur: 0.1,
      duration: 5.seconds.abs(),
    );
    _showWinDialog();
  }
}
