import 'package:ff_test/models/news_model.dart';
import 'package:ff_test/services/errors.dart';
import 'package:ff_test/services/providers.dart';
import 'package:flutter/material.dart';

class LoginRepositoriy {
  GlobalKey<ScaffoldMessengerState>? scaffoldKey;
  LoginProvider? loginProvider;
  LoginRepositoriy({@required this.scaffoldKey}) {
    loginProvider = LoginProvider(scaffoldKey: scaffoldKey);
  }

  Future<String> login(String? username, String? password) async {
    Map<String, dynamic> result =
        await loginProvider!.loginUser(username: username, password: password);
    if (result['error']) {
      Failure.showServerErrorMessage(
          errorData: result,
          currentState: scaffoldKey!.currentState!,
          duration: 3);
      return '';
    } else
      return result['data'];
  }
}

class NewsRepositoriy {
  GlobalKey<ScaffoldMessengerState>? scaffoldKey;
  NewsProvider? newsProvider;
  NewsRepositoriy({@required this.scaffoldKey}) {
    newsProvider = NewsProvider(scaffoldKey: scaffoldKey);
  }

  Future<List<NewsModel>> getNews() async {
    Map<String, dynamic> result = await newsProvider!.getNews();
    if (result['error']) {
      Failure.showServerErrorMessage(
          errorData: result,
          currentState: scaffoldKey!.currentState,
          duration: 3);
      return [];
    } else {
      return result['data'];
    }
  }
}
