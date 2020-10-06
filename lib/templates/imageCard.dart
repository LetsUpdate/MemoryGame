import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final Widget image;
  final String text;
  final double size;

  const ImageCard({
    Key key,
    @required this.image,
    this.text = "",
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? MediaQuery.of(context).size.width * 0.25;
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 25),
              ),
              Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black87),
                ),
                child: image,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
