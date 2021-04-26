# better_iflytek

A iFLYTEK SDK for flutter.

[语音评测 iOS SDK 文档] (https://www.xfyun.cn/doc/Ise/iOS-SDK.html)
[语音评测 Android SDK 文档] (https://www.xfyun.cn/doc/Ise/Android-SDK.html)

## Install Started

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  better_iflytek: ^0.0.1
```

2. Install it

```bash
$ flutter packages get
```

## Normal usage

```dart
  @override
  void initState() {
    super.initState();

    _iflytek = BetterIflytek();
    _iflytek?.initSDK('appid=$appid');
  }

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
```

## Feature
- [x] ISE
