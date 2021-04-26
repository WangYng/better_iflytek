# better_iflytek

A iFLYTEK SDK for flutter.

> [科大迅飞 iOS SDK 文档](https://www.xfyun.cn/doc/Ise/iOS-SDK.html) <br/>
> [科大迅飞 Android SDK 文档](https://www.xfyun.cn/doc/Ise/Android-SDK.html) <br/>

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
