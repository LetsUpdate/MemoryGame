import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pendroid_2020_part1/templates/imageCard.dart';
import 'package:pendroid_2020_part1/templates/lvlSettings.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  static const _title = {
    GameState.Show: "Remember",
    GameState.done: "Success",
    GameState.reorder: "Reorder The Tiles",
    GameState.failed: "Failed",
  };

  List<Widget> randomCards;
  GameState gameState;
  List<Widget> shuffeledCards;
  List<Widget> holderList;

  @override
  void initState() {
    randomCards = _orderGenerator();
    holderList = new List(randomCards.length);
    gameState = GameState.Show;
    shuffeledCards = Helper.shuffleList(randomCards.toList());

    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  void _setGameState(GameState state) {
    switch (state) {
      case GameState.reorder:
        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
        break;
      case GameState.Show:
        break;
      case GameState.done:
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        break;
      case GameState.failed:
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        break;
    }

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

    const textStyle1 = TextStyle(color: Colors.white, fontSize: 20);

    final orderedWidgets = _imageHolder(randomCards
        .map((e) => ImageCard(
              image: e,
              text: (randomCards.indexOf(e) + 1).toString(),
            ))
        .toList());

    switch (gameState) {
      case GameState.Show:
        body = Center(
          key: Key("show"),
          child: Column(
            children: [
              orderedWidgets,
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
        body = Center(
          key: Key("done"),
          child: Column(
            children: [orderedWidgets,
              RawMaterialButton(
                fillColor: Colors.green,
                splashColor: Colors.greenAccent,
                shape: const StadiumBorder(),
                onPressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            GameScreen(listOfAssets: widget.listOfAssets,
                              difficulty: widget.difficulty,))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],

          ),
        );
        break;
      case GameState.failed:
        int errors = 0;
        holderList.forEach((element) {
          if (element != randomCards[holderList.indexOf(element)]) errors++;
        });
        body = Center(
          key: Key('done'),
          child: Column(
            children: [
              _imageHolder(holderList
                  .map((e) =>
                  ImageCard(
                    image: Stack(
                      children: [
                        e,
                        e == randomCards[holderList.indexOf(e)]
                            ? Container()
                            : SvgPicture.asset('assets/redX.svg')
                      ],
                    ),
                    text: (holderList.indexOf(e) + 1).toString(),
                  ))
                  .toList()),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black54),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("You missed ${errors} objects", style: textStyle1,),
                    RawMaterialButton(
                      fillColor: Colors.blue,
                      splashColor: Colors.greenAccent,
                      shape: const StadiumBorder(),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Back to the menu',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ],

                ),
              )
            ],
          ),
        );
        break;
    }
    DateTime currentBackPressTime;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_title[gameState]),
        ),
        body: WillPopScope(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300), child: body),
              ),
              StreamBuilder(
                  stream: _stopWatchTimer.rawTime,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text("Timer error");
                    }
                    if (!snapshot.hasData) {
                      return Text("No data");
                    }
                    final int rawTime = snapshot.data;
                    final displayTime = StopWatchTimer.getDisplayTime(
                        rawTime,
                        hours: false,
                        milliSecond: true);

                    return Text(
                      displayTime,
                      style: TextStyle(fontSize: 30),
                    );
                  }),
            ],
          ),
          onWillPop: () {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime) > Duration(seconds: 2)) {
              currentBackPressTime = now;
              Fluttertoast.showToast(msg: "Press again to exit");
              return Future.value(false);
            }
            return Future.value(true);
          },
        ));
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
