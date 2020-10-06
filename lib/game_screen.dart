import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pendroid_2020_part1/templates/imageCard.dart';

class GameScreen extends StatefulWidget {
  final List<String> listOfAssets;

  const GameScreen({Key key, @required this.listOfAssets}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Widget> randomCards;

  @override
  void initState() {
    randomCards = _orderGenerator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> items = _composeRow();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('game'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items,
        ),
      ),
    );
  }

  int _howManyRow(int lenght) {
    final double rows = lenght / 3;
    if (lenght % 3 != 0) return rows.toInt() + 1;
    return rows.toInt();
  }

  List<Widget> _orderGenerator() {
    const length = 8;
    assert(length <= widget.listOfAssets.length);
    final copyOfAssets = widget.listOfAssets.toList();
    final randomList = [];
    final rand = new Random();
    for (int i = 0; i < length; i++) {
      final randomNum = rand.nextInt(copyOfAssets.length);
      randomList.add(SvgPicture.asset(copyOfAssets[randomNum]));
      copyOfAssets.removeAt(randomNum);
    }
    return randomList.cast<Widget>();
  }

  List<Row> _composeRow() {
    final rows = _howManyRow(randomCards.length);
    final List<Row> tableRows = [];
    int pieceLengthInRow = 3;
    for (int i = 0; i < rows; i++) {
      int minus = 0;
      if (randomCards.length == 4)
        pieceLengthInRow = 2;
      else if ((i + 1) * 3 > randomCards.length) {
        minus = (i + 1) * 3 - randomCards.length;
      }

      tableRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: randomCards
              .getRange(
                  i * pieceLengthInRow, ((i + 1) * pieceLengthInRow) - minus)
              .map((e) => Center(
                      child: ImageCard(
                    image: e,
                    text: (randomCards.indexOf(e) + 1).toString(),
                  )))
              .toList()));
    }
    return tableRows;
  }
}
