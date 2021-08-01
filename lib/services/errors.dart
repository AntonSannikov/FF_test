import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Failure {
  static void showServerErrorMessage(
      {@required ScaffoldMessengerState? currentState,
      @required int? duration,
      @required Map<String, dynamic>? errorData}) {
    String error_text = 'Неизвестная ошибка';
    switch (errorData!['data']) {
      case 400:
        error_text = 'Wrong login or password.';
        break;
      case 404:
        error_text = 'Requested resource not found. Check your settings.';
        break;
      case 500:
        error_text =
            'Internal server error. Please, try again later or contact with administrator.';
        break;
      case 524:
        error_text = 'A timeout occurred. Try again.';
        break;
    }
    currentState!.hideCurrentSnackBar();
    currentState.showSnackBar(SnackBar(
      content: Text(error_text),
      duration: Duration(seconds: duration!),
    ));
  }
}
