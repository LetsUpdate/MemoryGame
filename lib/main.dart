import 'package:flutter/material.dart';
import 'package:pendroid_2020_part1/asset_helper.dart';
import 'package:pendroid_2020_part1/game_screen.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('The memory game')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: RaisedButton(onPressed: _startGame, child: Text('Start'),))
        ],
      ),

    );
  }

  Future _startGame() async {
    final listOfAssets = await AssetHelper.getAssetPaths(context);
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameScreen(
              listOfAssets: listOfAssets,
              numberOfObjects: 4,
            )));
  }
}
