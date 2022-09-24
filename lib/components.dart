// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ChittyChatTitle extends StatelessWidget {
  final double width;
  final double height;

  const ChittyChatTitle({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RichText(
          softWrap: true,
          maxLines: 2,
          text: TextSpan(
              text: 'Chitty',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: width * 0.25,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = width * 0.02
                  ..color = Color(0xff37007C),
              ),
              children: [
                TextSpan(
                  text: 'Chat',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: width * 0.2,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = width * 0.02
                      ..color = Color(0xff37007C),
                  ),
                )
              ]),
        ),
        RichText(
          text: TextSpan(
              text: 'Chitty',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: width * 0.25,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: 'Chat',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: width * 0.2,
                    color: Colors.white,
                  ),
                )
              ]),
        ),
      ],
    );
  }
}
