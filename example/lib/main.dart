import 'dart:async';
import 'dart:math';

import 'package:download_manager/download_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _downloadManagerPlugin = DownloadManager();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _downloadManagerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(
        title: '',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    DownloadManager().registerCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  Random random = Random();
                  int randomNumber =
                      random.nextInt(10000); // from 0 upto 99 included
                  // var path = (await getApplicationDocumentsDirectory()).path;
                  DownloadManager().downloadFile(
                    url: "https://www.africau.edu/images/default/sample.pdf",
                    fileName: 'sample_$randomNumber',
                    // savedDir: path
                  );
                },
                child: const Text("download pdf")),
            ElevatedButton(
              onPressed: () {
                DownloadManager().viewDownloads();
              },
              child: const Text("View downloads"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("On Click noti"),
            )
          ],
        ),
      ),
    );
  }
}
