import 'package:ff_test/screens/login_screen/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ff_test/services/global.dart' as globals;

class LoginTextField extends StatefulWidget {
  LoginBloc? bloc;
  EdgeInsets? margin;
  String? labelText;
  bool? obscureText;
  double? height;
  BuildContext? context;
  String? type;

  LoginTextField(
      {Key? key,
      @required this.context,
      @required this.bloc,
      @required this.type,
      @required this.margin,
      @required this.labelText,
      @required this.obscureText,
      @required this.height})
      : super(key: key);

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  //
  //
  bool _nickNameError = false;
  AsyncSnapshot<String>? _snapshot;
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  MyNicknameFormatter? _nicknameFormatter;
  //
  //
  // OVERRIDED METHODS ---------------------------------------------------------
  //
  //
  @override
  void initState() {
    super.initState();
    _nicknameFormatter = MyNicknameFormatter(
        setErrorCallback: _setError, deleteErrorCallback: _deleteError);
    // listeners -------
    //
    _controller.addListener(
        () => widget.bloc!.updateText(_controller.text, widget.type));
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _focusNode.addListener(() => _getUnderlineBorder(
            context: context,
            settingState: true,
          ));
      //
      // listeners -------
    });
  }

  //
  //
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  //
  //############################################################################
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: (widget.type == 'nickname')
          ? widget.bloc?.nicknameStream
          : widget.bloc?.passwordStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        _snapshot = snapshot;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: widget.height,
              margin: widget.margin,
              decoration: BoxDecoration(
                  border: _getUnderlineBorder(
                context: context,
                settingState: false,
              )),
              child: Stack(
                children: <Widget>[
                  TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    obscureText: widget.obscureText!,
                    obscuringCharacter: '*',
                    inputFormatters: (widget.type == 'nickname')
                        ? [_nicknameFormatter!]
                        : null,
                    style: TextStyle(
                        height: 1.172,
                        letterSpacing: -0.02,
                        fontSize: 14 * globals.pixelRatio['height']!),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: (widget.height! - 12 * 1.172) / 2),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                  _getLabelText(),
                ],
              ),
            ),
            _drawErrorText(),
          ],
        );
      },
    );
  }

  //
  //
  // METHODS -------------------------------------------------------------------
  //
  //
  Widget _getLabelText() {
    return Text(
      widget.labelText!,
      style: TextStyle(
          height: 1.172,
          letterSpacing: -0.02,
          fontSize: 12 * globals.pixelRatio['height']!,
          color: Colors.grey.withOpacity(0.5),
          decoration: TextDecoration.none),
    );
  }

  //
  //
  void _setError() {
    _nickNameError = true;
    setState(() {});
  }

  //
  //
  void _deleteError() {
    _nickNameError = false;
    setState(() {});
  }

  //
  //
  Widget _drawErrorText() {
    if (widget.type == 'nickname' && _focusNode.hasFocus) {
      if (_nickNameError) {
        return Text(
          "Allowed latin letters and '_' character",
          style: TextStyle(
              height: 1.172,
              letterSpacing: -0.02,
              fontSize: 12 * globals.pixelRatio['height']!,
              color: Colors.grey.shade400,
              decoration: TextDecoration.none),
        );
      } else
        return SizedBox.shrink();
    }

    if (widget.type == 'password' && _snapshot!.hasError)
      return Text(
        _snapshot!.error as String,
        style: TextStyle(
            height: 1.172,
            letterSpacing: -0.02,
            fontSize: 12 * globals.pixelRatio['height']!,
            color: Colors.red,
            decoration: TextDecoration.none),
      );
    else
      return SizedBox.shrink();
  }

  //
  //
  Border _getUnderlineBorder(
      {@required bool? settingState, @required BuildContext? context}) {
    Color _color;
    double _width;

    if (_focusNode.hasFocus) {
      _width = 2 * globals.pixelRatio['height']!;
      if (_snapshot!.hasError && widget.type != 'nickname')
        _color = Colors.red;
      else
        _color = Colors.blue;
    } else {
      _width = globals.pixelRatio['height']!;
      if (_snapshot!.hasError)
        _color = Colors.red;
      else
        _color = Colors.grey.shade300;
    }

    if (settingState!) setState(() {});

    return Border(
      bottom: BorderSide(color: _color, width: _width),
    );
  }
}

//
//
//
//
class MyNicknameFormatter extends TextInputFormatter {
  Function? setErrorCallback;
  Function? deleteErrorCallback;
  bool error = false;
  MyNicknameFormatter(
      {@required this.setErrorCallback, @required this.deleteErrorCallback});
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;
    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    if (cText == pText)
      return TextEditingValue(
          text: cText,
          selection: TextSelection.collapsed(offset: cText.length));
    if (cText.length == 0)
      return TextEditingValue(
          text: '', selection: TextSelection.collapsed(offset: 0));

    final RegExp _regExp = RegExp(r'[A-Za-z_]+$');

    if (!(_regExp.allMatches(cText).length != 0 || cText.length == 0)) {
      cText = pText;
      setErrorCallback!();
    } else
      deleteErrorCallback!();

    selectionIndex = cText.length;

    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
