import 'dart:collection';

import 'package:flutter/services.dart';

class BetterIflytekApi {
  Future<void> initSDK(String appId) async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_iflytek.initSDK', StandardMessageCodec());
    final Map<String, dynamic> requestMap = {"appId": appId};
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }
  }

  Future<void> setParameter(Map<String, dynamic> params) async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_iflytek.setParameter', StandardMessageCodec());
    final reply = await channel.send(params);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }
  }

  Future<Stream> startEvaluating(String evaluatingText) async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_iflytek.startEvaluating', StandardMessageCodec());
    final Map<String, dynamic> requestMap = {"evaluatingText": evaluatingText};
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }

    return EventChannel("com.wangyng.better_iflytek/evaluatorListenerEvent").receiveBroadcastStream();
  }

  Future<void> stopEvaluating() async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_iflytek.stopEvaluating', StandardMessageCodec());
    final reply = await channel.send({});

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }
  }

  Future<void> dispose() async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_iflytek.dispose', StandardMessageCodec());
    final reply = await channel.send({});

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }
  }
}

_throwChannelException() {
  throw PlatformException(code: 'channel-error', message: 'Unable to establish connection on channel.', details: null);
}

_throwException(HashMap<String, dynamic> error) {
  throw PlatformException(code: error['code'], message: error['message'], details: error['details']);
}
