import 'package:better_iflytek_example/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:better_iflytek/better_iflytek.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PermissionStatus? permissionStatus;

  StreamSubscription? _subscription;

  BetterIflytek? _iflytek;

  String? onResult;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _iflytek = BetterIflytek();
    _iflytek?.initSDK('appid=$appid');

    Future.microtask(() async {
      PermissionStatus permissionStatus = await Permission.microphone.status;
      setState(() {
        this.permissionStatus = permissionStatus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Offstage(
                offstage: permissionStatus == PermissionStatus.granted,
                child: CupertinoButton(
                  child: Text("request microphone permission"),
                  onPressed: () async {
                    final value = await Permission.microphone.request();
                    if (value == PermissionStatus.permanentlyDenied || value == PermissionStatus.restricted) {
                      openAppSettings();
                    }

                    setState(() {
                      permissionStatus = value;
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: Text("start"),
                onPressed: () {
                  processEvaluatingResult();
                  _iflytek?.startEvaluating("[word]apple");
                },
              ),
              CupertinoButton(
                child: Text("stop"),
                onPressed: () {
                  _iflytek?.stopEvaluating();
                },
              ),
              CupertinoButton(
                child: Text("clean"),
                onPressed: () {
                  setState(() {
                    onResult = "";
                  });
                },
              ),
              Text(onResult ?? ""),
            ],
          ),
        ),
      ),
    );
  }

  void processEvaluatingResult() async {
    _subscription?.cancel();
    _subscription = _iflytek?.getStartEvaluatingStream().listen((event) async {
      if (event.item1 == BetterIflytekEvent.OnResult) {
        setState(() {
          onResult = event.item2.toString();
        });

        final path = await _iflytek?.audioPath();
        if (path != null) {
          audioPlayer.setFilePath(path);
          audioPlayer.play();
        }
      }
    });
  }

  @override
  void dispose() {
    _iflytek?.dispose();
    _subscription?.cancel();
    super.dispose();
  }
}
