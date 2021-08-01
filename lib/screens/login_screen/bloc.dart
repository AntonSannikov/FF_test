import 'dart:async';
import 'package:ff_test/services/global.dart' as globals;
import 'package:ff_test/services/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

//
//
//
// Events
abstract class LoginEvent {}

class LoginResetEvent extends LoginEvent {}

class LoginStartEvent extends LoginEvent {}

class LoginDoneEvent extends LoginEvent {}

//
//
//
// States
abstract class LoginState {}

class LoginLoadingState extends LoginState {}

class LoginDoneState extends LoginState {}

class LoginErrorState extends LoginState {}

class LoginInitialState extends LoginState {}

//
//
//
//
//------------------------------------------------------------------------------
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //
  //
  String? _nickname;
  String? _password;
  bool? _passwordError = false;
  final LoginRepositoriy? loginRepositoriy;
  final Subject<String> _nicknameController = PublishSubject<String>();
  final Subject<String> _passwordController = PublishSubject<String>();
  Stream<String> get nicknameStream => _nicknameController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  //
  //
  LoginBloc({@required this.loginRepositoriy}) : super(LoginInitialState());
  //
  //
  void updateText(String text, String? type) {
    if (type == 'nickname') _nickname = text;
    _nicknameController.sink.add(text);
    if (type == 'password') {
      _password = text;
      if (text.length < 3 || text.length > 9) {
        _passwordError = true;
        _passwordController.sink
            .addError("Password must be from 3 to 9 characters");
      } else if (_passwordError!) {
        _passwordError = false;
        _passwordController.sink.add(text);
      }
    }
  }

//
//
  bool validateText() {
    if ((_nickname != null && _password != null) &&
        (_password!.length >= 3 &&
            _password!.length <= 9 &&
            _nickname!.length > 0)) return true;
    return false;
  }

  //
  //
  void dispose() {
    _nicknameController.close();
    _passwordController.close();
  }

  //
  //
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case LoginResetEvent:
        yield LoginInitialState();
        break;
      case LoginStartEvent:
        yield LoginLoadingState();
        globals.access_token = '';
        globals.access_token =
            await loginRepositoriy!.login(_nickname, _password);
        if (globals.access_token!.length > 0) {
          this.add(LoginDoneEvent());
        } else
          yield LoginInitialState();
        break;
      case LoginDoneEvent:
        yield LoginDoneState();
        break;
    }
  }
}
