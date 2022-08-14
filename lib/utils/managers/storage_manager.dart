import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageManager {
  StorageManager(this.path, [this.isLocal = true]);

  final String path;
  final bool isLocal;

  Future<String?> read() async {
    try {
      return (await _file).readAsStringSync();
    } catch (e) {
      print('error => $e');
      return null;
    }
  }

  Future<void> write(String contents) async {
    try {
      (await _file).writeAsStringSync(contents);
    } catch (e) {
      print('error => $e');
    }
  }

  Future<List<String>?> get files async {
    try {
      return (await _directory)
          .map((e) => e.path)
          .where((e) => FileSystemEntity.isFileSync(e))
          .toList();
    } catch (e) {
      print('error => $e');
      return null;
    }
  }

  Future<String> get documents async =>
      (await getApplicationDocumentsDirectory()).path;

  Future<String> get _path async => isLocal ? '${await documents}/$path' : path;

  Future<List<FileSystemEntity>> get _directory async =>
      Directory(await _path).listSync(recursive: true);

  Future<File> get _file async => File(await _path).create(recursive: true);
}
