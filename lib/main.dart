import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    final dir = Directory('$path/Scripts').listSync();
    for (final f in dir) {
      print(f.path);
    }

    return await File('$path/Scripts/script33.js').create(recursive: true);
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = file.readAsStringSync();
      print('contents => $contents');
      return int.parse(contents);
    } catch (e) {
      print(e);
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<void> writeCounter(int counter) async {
    final file = await _localFile;
    file.writeAsStringSync('$counter');
  }
}

class _MyAppState extends State<MyApp> {
  final String _jsResult = '';
  JavascriptRuntime? flutterJs;

  final CounterStorage storage = CounterStorage();
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });

    flutterJs = getJavascriptRuntime();
    flutterJs?.onMessage('someChannelName', (dynamic args) {
      print(args);
    });
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    await storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterJS Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_counter.toString()),
              Text('JS Evaluate Result: $_jsResult\n'),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    'Click on the big JS Yellow Button to evaluate the expression bellow using the flutter_js plugin'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Math.trunc(Math.random() * 100).toString();",
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          // child: Image.asset('assets/js.ico'),
          onPressed: () async {
            final code1 = """
           sendMessage('someChannelName', JSON.stringify([1,2,3]));
           sendMessage('someChannelName', 234234324);
            """;

            final code2 = """
              const MyClass = class {
                constructor(id) {
                  this.id = id;
                }
                
                getId() { 
                  return this.id;
                }
              }
            """;

            final code3 = """
               var obj = new MyClass(1534);
                var jsonStringified = JSON.stringify(obj);
                var value = Math.trunc(Math.random() * 100).toString();
                sendMessage('someChannelName',
                  JSON.stringify({ "object": jsonStringified, "expression": value})
                );
            """;

            final codes = [
              code2,
              code3,
            ];

            _incrementCounter();

            for (final code in codes) {
              await flutterJs?.evaluateAsync(code);
            }
          },
        ),
      ),
    );
  }
}
