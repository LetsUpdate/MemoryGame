import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pendroid_2020_part1/game_screen.dart';
import 'package:pendroid_2020_part1/helper.dart';
import 'package:pendroid_2020_part1/templates/imageCard.dart';
import 'package:pendroid_2020_part1/templates/lvlSettings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MenuPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static const DIFFICULTY_LIST = [
    const LvlSettings(4),
    const LvlSettings(6),
    const LvlSettings(6, roundDuration: Duration(seconds: 30))
  ];
  int difficultyLvl = 0;
  List<String> listOfAssets;

  List<Widget> _backgroundTiles;

  static const textStyle1 = const TextStyle(color: Colors.white, fontSize: 18);
  static const titleStyle = const TextStyle(fontSize: 25, color: Colors.white);

  void _changeBackground() {
    setState(() {
      _backgroundTiles = Helper.shuffleList(listOfAssets.toList())
          .sublist(0, 6)
          .map((e) => ImageCard(image: SvgPicture.asset(e)))
          .toList();
    });
  }

  @override
  void initState() {
    Helper.getAssetPaths(context).then((value) {
      listOfAssets = value;
      _changeBackground();
      Timer.periodic(Duration(seconds: 30), (timer) {
        _changeBackground();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: const Text('The memory game')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black54),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Difficulty',
                        style: titleStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CheckArea(
                        text: "Easy",
                        value: difficultyLvl == 0,
                        onClick: () {
                          setState(() {
                            difficultyLvl = 0;
                          });
                        },
                      ),
                      CheckArea(
                        text: "Normal",
                        value: difficultyLvl == 1,
                        onClick: () {
                          setState(() {
                            difficultyLvl = 1;
                          });
                        },
                      ),
                      CheckArea(
                        text: "Stress",
                        value: difficultyLvl == 2,
                        onClick: () {
                          setState(() {
                            difficultyLvl = 2;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Number of objects: ${DIFFICULTY_LIST[difficultyLvl].numberOfTiles}",
                          style: textStyle1,
                        ),
                        Text(
                          "Time limit: ${DIFFICULTY_LIST[difficultyLvl].isStress ? DIFFICULTY_LIST[difficultyLvl].roundDuration.inSeconds.toString() + " seconds" : "limit less"}",
                          style: textStyle1,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    listOfAssets == null
                        ? Container()
                        : AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: Column(
                              key: Key(_backgroundTiles.hashCode.toString()),
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children:
                                      _backgroundTiles.sublist(0, 3).toList(),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      _backgroundTiles.sublist(3, 6).toList(),
                                )
                              ],
                            ),
                          ),
                    RawMaterialButton(
                      fillColor: Colors.blue,
                      splashColor: Colors.greenAccent,
                      shape: const StadiumBorder(),
                      onPressed: _startGame,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Play and have fun',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black54),
              child: Column(
                children: [
                  Text("Statistics", style: titleStyle),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45),
                    child: Column(
                      children: [
                        Text(
                          "Your fail rate is: ",
                          style: textStyle1,
                        ),
                        Text(
                          "You spent x minutes in the game ",
                          style: textStyle1,
                        ),
                        Text(
                          "asd",
                          style: textStyle1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _startGame() async {
    final listOfAssets = this.listOfAssets ??
        await Helper.getAssetPaths(context);
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            GameScreen(
              listOfAssets: listOfAssets,
              difficulty: DIFFICULTY_LIST[difficultyLvl],
            )));
  }
}

class CheckArea extends StatelessWidget {
  final String text;
  final bool value;
  final VoidCallback onClick;

  const CheckArea({
    Key key,
    this.onClick,
    this.text = '',
    this.value = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: value ? Colors.blue : Colors.grey,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
