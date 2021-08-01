import 'package:ff_test/screens/login_screen/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ff_test/services/global.dart' as globals;
import 'package:rxdart/rxdart.dart';

class SignInButton extends StatefulWidget {
  //
  //
  LinearGradient? gradient;
  //
  //
  SignInButton({Key? key, @required this.gradient}) : super(key: key);

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

//
//
//
//
class _SignInButtonState extends State<SignInButton> {
  //
  //
  //############################################################################
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of(context);
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) => Container(
        margin: EdgeInsets.only(top: 44 * globals.pixelRatio['height']!),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(3 * globals.pixelRatio['height']!)),
            gradient: widget.gradient),
        child: StreamBuilder(
            stream: Rx.combineLatestList(
                [loginBloc.nicknameStream, loginBloc.passwordStream]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.transparent,
                  minimumSize:
                      Size(double.infinity, 53 * globals.pixelRatio['height']!),
                ),
                onPressed: (snapshot.hasData && loginBloc.validateText())
                    ? () {
                        if (state is! LoginLoadingState) {
                          FocusScope.of(context).unfocus();
                          loginBloc.add(LoginStartEvent());
                        }
                      }
                    : null,
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 19),
                ),
              );
            }),
      ),
    );
  }
}
