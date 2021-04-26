import 'package:better_iflytek_example/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:better_iflytek/better_iflytek.dart';
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

      print("permissionStatus $permissionStatus");
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
                  Future<Stream<Tuple2<BetterIflytekEvent, dynamic>>>? result =
                      _iflytek?.startEvaluating("[word]apple");
                  if (result != null) {
                    result.then((value) {
                      processEvaluatingResult(value);
                    });
                  }
                },
              ),
              CupertinoButton(
                child: Text("stop"),
                onPressed: () {
                  _iflytek?.stopEvaluating();
                },
              ),
              Text(onResult ?? ""),
            ],
          ),
        ),
      ),
    );
  }

  void processEvaluatingResult(Stream<Tuple2<BetterIflytekEvent, dynamic>> stream) async {
    _subscription = stream.listen((event) {
      if (event.item1 == BetterIflytekEvent.OnResult) {
        setState(() {
          onResult = event.item2.toString();
        });
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
