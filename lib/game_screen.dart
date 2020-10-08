import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pendroid_2020_part1/templates/imageCard.dart';
import 'package:pendroid_2020_part1/templates/lvlSettings.dart';

import 'helper.dart';

class GameScreen extends StatefulWidget {
  final List<String> listOfAssets;
  final LvlSettings difficulty;

  const GameScreen(
      {Key key, @required this.listOfAssets, @required this.difficulty})
      : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

/*
  * Show the order
  * swap them
  * you need to re order
  * if you can you can go to the next lvl
 */
class _GameScreenState extends State<GameScreen> {
  List<Widget> randomCards;
  GameState gameState;
  List<Widget> shuffeledCards;
  List<Widget> holderList;

  static const _title = {
    GameState.Show: "Remember",
    GameState.done: "Success",
    GameState.reorder: "Reorder The Tiles",
    GameState.failed: "Failed",
  };

  @override
  void initState() {
    randomCards = _orderGenerator();
    holderList = new List(randomCards.length);
    gameState = GameState.Show;
    shuffeledCards = Helper.shuffleList(randomCards.toList());
    super.initState();
  }

  void _setGameState(GameState state) {
    setState(() {
      gameState = state;
    });
  }

  Widget _imageHolder(List<Widget> children) {
    return Wrap(
      children: children,
      alignment: WrapAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (gameState) {
      case GameState.Show:
        body = Center(
          key: Key("show"),
          child: Column(
            children: [
              _imageHolder(randomCards
                  .map((e) => ImageCard(
                        image: e,
                        text: (randomCards.indexOf(e) + 1).toString(),
                      ))
                  .toList()),
              RaisedButton(
                onPressed: () => _setGameState(GameState.reorder),
                child: Text('Reorder!'),
              )
            ],
          ),
        );
        break;

      case GameState.reorder:
        body = Center(
            key: Key("reorder"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _imageHolder(randomCards
                    .map((e) =>
                    ImageCard(
                      image: DragTarget<Widget>(
                        builder: (context, list1, list2) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                holderList[randomCards.indexOf(e)] = null;
                              });
                            },
                            child: holderList[randomCards.indexOf(e)] ??
                                Container(),
                          );
                        },
                        onAccept: (data) {
                          print("accept");
                          setState(() {
                            holderList[randomCards.indexOf(e)] = data;
                            if (_isFull()) {
                              if (_isGood())
                                _setGameState(GameState.done);
                              else
                                _setGameState(GameState.failed);
                            }
                          });
                        },
                      ),
                      text: (randomCards.indexOf(e) + 1).toString(),
                    ))
                    .toList()),
                Wrap(
                  alignment: WrapAlignment.center,
                  verticalDirection: VerticalDirection.up,
                  children: shuffeledCards.map((e) {
                    final isDisabled = holderList.contains(e);
                    final child = ImageCard(
                      image: isDisabled ? Container() : e,
                    );

                    return Draggable<Widget>(
                      maxSimultaneousDrags: isDisabled ? 0 : null,
                      feedback: Material(
                        child: child,
                        color: Colors.transparent,
                      ),
                      child: child,
                      childWhenDragging: ImageCard(
                        image: SizedBox(),
                      ),
                      data: e,
                    );
                  }).toList(),
                )
              ],
            ));
        break;
      case GameState.done:
        body = Text("done");
        break;
      case GameState.failed:
        body = Center(
          key: Key('done'),
          child: Column(
            children: [
              _imageHolder(holderList.map((e) =>
                  ImageCard(
                    image: Stack(children: [
                      e,
                      e == randomCards[holderList.indexOf(e)]
                          ? Container()
                          : SvgPicture.asset('assets/redX.svg')
                    ],), text: (holderList.indexOf(e) + 1).toString(),))
                  .toList())
            ],
          ),
        );
        break;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_title[gameState]),
        ),
        body: AnimatedSwitcher(
            duration: Duration(milliseconds: 300), child: body));
  }

  //region helpers


  List<Widget> _orderGenerator() {
    assert(widget.difficulty.numberOfTiles <= widget.listOfAssets.length);
    final copyOfAssets = widget.listOfAssets.toList();
    final randomList = [];
    final rand = new Random();
    for (int i = 0; i < widget.difficulty.numberOfTiles; i++) {
      final randomNum = rand.nextInt(copyOfAssets.length);
      randomList.add(SvgPicture.asset(copyOfAssets[randomNum]));
      copyOfAssets.removeAt(randomNum);
    }
    return randomList.cast<Widget>();
  }

  bool _isFull() {
    return !holderList.contains(null);
  }

  bool _isGood() {
    return listEquals(randomCards, holderList);
  }
//endregion
}

enum GameState { Show, reorder, done, failed }
