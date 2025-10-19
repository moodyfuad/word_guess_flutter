import 'package:word_guess/util/constants/random_words.dart';

String getRandomWordImp(int length) {
    // int index = Random.secure().nextInt(arabicWords6.length) - 1;
    arabicWords6.shuffle();

    final selected = arabicWords6.firstWhere((word) => word.length == length);

    if (selected.length == length) {
      return selected;
    } else {
      return getRandomWordImp(length);
    }
  }