import 'dart:convert';

import 'package:flutter/cupertino.dart';

class AssetHelper {
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
}
