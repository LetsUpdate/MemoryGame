import 'package:flutter/cupertino.dart';
import 'package:pendroid_2020_part1/asset_helper.dart';

class Global {
  List<String> assetList;

  Future init(BuildContext context) async {
    assetList = await AssetHelper.getAssetPaths(context);
  }
}

final Global globals = Global();
