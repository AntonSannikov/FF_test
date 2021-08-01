import 'package:ff_test/screens/login_screen/bloc.dart';
import 'package:ff_test/screens/login_screen/widgets/signIn_button.dart';
import 'package:ff_test/services/global.dart' as globals;
import 'package:ff_test/screens/login_screen/widgets/login_TextField.dart';
import 'package:ff_test/services/navigator.dart';
import 'package:ff_test/services/repositories.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  //
  LoginBloc? _loginBloc;
  GlobalKey<ScaffoldMessengerState>? _loginScaffoldKey;
  //
  //
  final LinearGradient _gradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    transform: GradientRotation(224.07 * math.pi / 180),
    colors: <Color>[
      globals.loginLighterColor,
      globals.loginDarkerColor,
    ],
    stops: const <double>[0.0362, 0.9616],
  );
  //
  //
  // OVERRIDED METHODS ---------------------------------------------------------
  //
  //
  @override
  void initState() {
    super.initState();
    _loginScaffoldKey = GlobalKey<ScaffoldMessengerState>();
    final LoginRepositoriy _loginRepositoriy =
        LoginRepositoriy(scaffoldKey: _loginScaffoldKey);
    _loginBloc = LoginBloc(loginRepositoriy: _loginRepositoriy);
  }

  //
  //
  @override
  void dispose() {
    _loginBloc?.dispose();
    _loginBloc = null;
    super.dispose();
  }

  //
  //############################################################################
  @override
  Widget build(BuildContext context) {
    _setPrototypeRatio(context: context);
    return BlocProvider<LoginBloc>(
      create: (context) => _loginBloc!,
      child: BlocListener(
        bloc: _loginBloc!,
        listener: (BuildContext context, state) {
          if (state is LoginDoneState) {
            _loginBloc!.add(LoginResetEvent());
            AppNavigator(context: context).navigateTo(pageName: 'home');
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: ScaffoldMessenger(
            key: _loginScaffoldKey,
            child: Container(
              decoration:
                  BoxDecoration(color: Colors.white, gradient: _gradient),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) => Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: (state is LoginInitialState) ? 1 : 0.2,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 16 * globals.pixelRatio['width']!,
                                right: 16 * globals.pixelRatio['width']!,
                                top: 40 * globals.pixelRatio['height']!),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: (80 -
                                          MediaQuery.of(context).padding.top) *
                                      globals.pixelRatio['height']!,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 48 * globals.pixelRatio['height']!),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Authorization',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.4)),
                                      ),
                                      // white input form
                                      _getLoginForm(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (state is LoginLoadingState) ? true : false,
                        child: Center(
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
  //
  // METHODS -------------------------------------------------------------------
  //
  //
  void _setPrototypeRatio({@required BuildContext? context}) {
    if (globals.pixelRatio['received'] == 0)
      globals.pixelRatio = {
        'height': MediaQuery.of(context!).size.height / 650,
        'width': MediaQuery.of(context).size.width / 360,
        'received': 1
      };
  }

  //
  //
  Widget _getLoginForm() {
    return Container(
      margin: EdgeInsets.only(top: globals.pixelRatio['height']!),
      padding: EdgeInsets.only(
          left: 30 * globals.pixelRatio['width']!,
          right: 30 * globals.pixelRatio['width']!,
          bottom: 34 * globals.pixelRatio['height']!),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40 * globals.pixelRatio['height']!),
            bottomRight: Radius.circular(40 * globals.pixelRatio['height']!),
            topRight: Radius.circular(4 * globals.pixelRatio['height']!),
            bottomLeft: Radius.circular(4 * globals.pixelRatio['height']!)),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(38, 0, 0, 0),
              blurRadius: 60 * globals.pixelRatio['height']!),
        ],
      ),
      child: Column(
        children: <Widget>[
          // nickname field
          LoginTextField(
              type: 'nickname',
              context: context,
              bloc: _loginBloc,
              margin: EdgeInsets.only(top: 50 * globals.pixelRatio['height']!),
              height: 39 * globals.pixelRatio['height']!,
              labelText: 'Nickname',
              obscureText: false),
          // pass field
          LoginTextField(
              type: 'password',
              context: context,
              bloc: _loginBloc,
              margin: EdgeInsets.only(top: 30 * globals.pixelRatio['height']!),
              height: 39 * globals.pixelRatio['height']!,
              labelText: 'Password',
              obscureText: true),
          // sign in button
          SignInButton(gradient: _gradient),
          // policies group
          Container(
            height: 57 * globals.pixelRatio['height']!,
            color: Colors.blue,
            margin: EdgeInsets.only(top: 30 * globals.pixelRatio['height']!),
            child: Center(
              child: Text('Policies Group'),
            ),
          ),
        ],
      ),
    );
  }
}
