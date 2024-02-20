import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {
  Function event;
  final String text;
  Color color;
  ButtonApp({
    Key? key,
    required this.event,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 100,
        height: 100,
        color: Colors.amber,
      ),
    );
  }
}
