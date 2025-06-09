import 'package:flutter_translate/flutter_translate.dart';

class Validators {
  /// Check if a text is empty
  static String? isTextEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return translate('insert_something_desc');
    }
    return null;
  }
}
