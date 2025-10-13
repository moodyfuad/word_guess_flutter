import 'package:get/get.dart';
import 'package:word_guess/localization/home_page_strings.dart';

class XTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar':{
      'key':'value',
      ...XHomePageStrings.ar
    },
    'en':{
      'key':'value'
    }
  };
}