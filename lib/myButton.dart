import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  final Color color;

  const MyButton(
      {Key key, this.onPressed, this.text = "", this.color = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: color,
      splashColor: color.withOpacity(0.7),
      shape: const StadiumBorder(),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
    ;
  }
}
