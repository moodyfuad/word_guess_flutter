
import 'package:flutter/material.dart';
import 'package:word_guess/features/single_player/models/letter_states.dart';

Color? getLetterColorByStateImp(String state) {
    return switch (state) {
      XLetterStates.correct => Colors.green,
      XLetterStates.present => Colors.amberAccent,
      XLetterStates.absent => Colors.blueGrey,
      XLetterStates.none => Colors.blue[100],
      XLetterStates.empty => Colors.white,
      _ => Colors.black,
    };
  }