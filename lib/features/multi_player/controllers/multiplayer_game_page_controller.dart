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
  final double _letterHeight = 64;

  final scrollController = ScrollController(keepScrollOffset: true);

  int get attempts => room?.maxAttempts ?? 0;
  int get wordLength => room?.wordLength ?? 0;
  LetterModel get _currentLetter => board[_currentRow].letters[_currentCol];
  final _storage = Get.find<StorageService>();
  get room => _options.room;
  // final _options = Get.find<MultiplayerOptionsPageController>();
  final _options = Get.find<RoomController>();

  bool _iWon = false;
  bool _opponentWon = false;

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
        _animateListView();
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
    _animateListView();
  }

  void _checkWinCase(WordModel word, bool forMe) {
    final bool win = word.letters.every(
      (letter) => letter.state == XLetterStates.correct,
    );
    if (win && forMe) {
      _storage.increasePlayedCount();
      _storage.increaseWinCount();
      _iWon = true;
      _sendPlayerScore();
      _showWinDialog();
    } else if (win && !forMe) {
      _storage.increasePlayedCount();
      _opponentWon = true;
      _sendPlayerScore();
      _showLoseDialog();
    }
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
    // todo : check
    if (_iWon || _opponentWon) {
      return;
    } else {
      await _api.post(
        'room/leaveGame',
        data: {'roomKey': room?.key, 'playerId': _storage.playerId},
      );
    }
  }

  handelPop() async {
    if (_iWon || _opponentWon) {
      Get.until(
        (route) => ![
          XRoutes.multiplayerGame,
          XRoutes.selectWord,
          // XRoutes.multiplayerOptions,
        ].contains(Get.currentRoute),
      );
    } else {
      final d = await Helper.showOnWillPopDialog('تنبيه', [
        'سيتم احتساب النتيجة كخسارة',
        'هل ترغب في مغادرة الغرفة ؟',
      ], onResult: (val) {});

      if (d) {
        //todo: update the score
        if (!_iWon && !_opponentWon) {
          _storage.increasePlayedCount();
          await _leaveGame();
          //todo: send leave game to the opponent
        }
        Get.until(
          (route) => ![
            XRoutes.multiplayerGame,
            XRoutes.selectWord,
            // XRoutes.multiplayerOptions,
          ].contains(Get.currentRoute),
        );
      }
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
  _animateListView() {
    if (_currentRow > 5) {
      scrollController.animateTo(
        _letterHeight * (_currentRow - 5).toDouble(),
        curve: Curves.easeInOut,
        duration: 0.2.seconds.abs(),
      );
    }
  }

  //^ Dialogs
  _showWinDialog() async {
    _iWon = true;
    await Helper.showDialog(
      '🎉 فائز',
      children: [
        Text(
          'مبروك الفوز',
          style: Get.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          'الان سيتم تحويلك لصفحة البداية',
          style: Get.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
      confirmText: 'تأكيد',
      onConfirm: () {
        Get.until(
          (route) => ![
            XRoutes.multiplayerGame,
            XRoutes.selectWord,
            // XRoutes.multiplayerOptions,
          ].contains(Get.currentRoute),
        );
      },
    );
  }

  _showLoseDialog() {
    _opponentWon = true;
    _hub.onOpponentLeftGame = null;
    Helper.showDialog(
      '😆 خاسر 😆',
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
      confirmText: 'تأكيد',
      onConfirm: () {
        Get.until(
          (route) => ![
            XRoutes.multiplayerGame,
            XRoutes.selectWord,
          ].contains(Get.currentRoute),
        );
      },
    );
  }

  void _handleOpponentLeftGame() {
    Helper.showSnackbar(
      'انقطع الاتصال عند الخصم',
      'تم احتساب فوزك بشكل تلقائي',
      SnackbarTypes.info,
    );
    _showWinDialog();
  }
}
