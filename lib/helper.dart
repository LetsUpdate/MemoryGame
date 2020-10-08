import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';

class Helper {
  static Future<List<String>> getAssetPaths(BuildContext context) async {
    final manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final List<String> imagePats = json
        .decode(manifestJson)
        .keys
        .where((String key) => key.startsWith('assets/objects'))
        .toList();
    return imagePats;
  }

  static List shuffleList(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
}
