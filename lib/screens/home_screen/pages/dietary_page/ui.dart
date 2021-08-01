import 'package:flutter/material.dart';

class DietaryPage extends StatefulWidget {
  DietaryPage({Key? key}) : super(key: key);

  @override
  _DietaryPageState createState() => _DietaryPageState();
}

class _DietaryPageState extends State<DietaryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Dietary Page'),
      ),
    );
  }
}
