import 'dart:convert';
import 'package:ff_test/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ff_test/services/global.dart' as globals;

class LoginProvider {
  GlobalKey<ScaffoldMessengerState>? scaffoldKey;
  LoginProvider({@required this.scaffoldKey});
  final client = http.Client();
  Future<Map<String, dynamic>> loginUser(
      {@required String? username, @required String? password}) async {
    final body = {'username': username, 'password': password};
    final response = await client.post(
        Uri.parse('https://app.ferfit.club/api/auth/refresh-tokens'),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer ${globals.bearer_token}'
        }).timeout(Duration(seconds: 5), onTimeout: () {
      return http.Response('', 524);
    });

    if (response.statusCode == 200)
      return {
        'error': false,
        'data': json.decode(response.body)['result']['access']
      };
    else
      return {'error': true, 'data': response.statusCode};
  }
}

class NewsProvider {
  GlobalKey<ScaffoldMessengerState>? scaffoldKey;
  NewsProvider({@required this.scaffoldKey});
  final client = http.Client();
  Future<Map<String, dynamic>> getNews() async {
    final response = await client.get(
        Uri.parse(
            'https://app.ferfit.club/api/feed?limit=10&offset=0&maxDate=2021-05-06T18:26:42.820994'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer ${globals.access_token}'
        });

    if (response.statusCode == 200) {
      final List newsJson =
          json.decode(utf8.decode(response.bodyBytes))['result']['posts'];
      return {
        'error': false,
        'data': newsJson.map((news) => NewsModel.fromJson(news)).toList()
      };
    } else
      return {'error': true, 'data': response.reasonPhrase.toString()};
  }
}
