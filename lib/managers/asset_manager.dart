import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mana_studio/config/asset_config.dart';

const _assetManifest = 'AssetManifest.json';

class AssetManager {
  AssetManager([this.assetsPath = imagesAssets, this.fileName = '', this.ext = pngExt]);

  final String assetsPath;
  final String fileName;
  final String ext;

  String get path => '$assetsPath/$fileName$ext';

  Future<Map<String, dynamic>> get loadAssetManifest async => json.decode(await rootBundle.loadString(_assetManifest));

  Future<String> get loadString async => rootBundle.loadString(path);

  Future<dynamic> get decodeJson async => json.decode(await loadString);
}
