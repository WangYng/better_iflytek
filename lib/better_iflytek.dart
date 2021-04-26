import 'dart:async';

import 'package:better_iflytek/better_iflytek_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

enum BetterIflytekEvent {
  OnVolumeChanged,
  OnBeginOfSpeech,
  OnEndOfSpeech,
  OnResult,
  OnError,
  Unknown,
}

class BetterIflytek {
  final _api = BetterIflytekApi();

  Future<void> initSDK(String appId) async {
    final audioPath = (await getTemporaryDirectory()).path + "/msc/ise.wav";
    await _api.initSDK(appId);
    await _api.setParameter({
      'language': 'en_us',
      'category': 'read_word',
      'text_encoding': 'utf-8',
      'vad_bos': 5000,
      'vad_eos': 1800,
      'speech_timeout': -1,
      'result_level': 'plain',
      'aue': 'opus',
      'audio_format': 'wav',
      'ise_audio_path': audioPath,
    });
  }

  Future<void> setParameter(Map<String, dynamic> params) async {
    await _api.setParameter(params);
  }

  Future<Stream<Tuple2<BetterIflytekEvent, dynamic>>> startEvaluating(String evaluatingText) async {
    Stream stream = await _api.startEvaluating(evaluatingText);
    return stream.where((event) {
      return event is Map;
    }).map((event) {
      String name = event['name'];
      dynamic details = event['details'];

      BetterIflytekEvent eventName;
      switch (name) {
        case 'onVolumeChanged':
          eventName = BetterIflytekEvent.OnVolumeChanged;
          break;
        case 'onBeginOfSpeech':
          eventName = BetterIflytekEvent.OnBeginOfSpeech;
          break;
        case 'onEndOfSpeech':
          eventName = BetterIflytekEvent.OnEndOfSpeech;
          break;
        case 'onResult':
          eventName = BetterIflytekEvent.OnResult;
          break;
        case 'onError':
          eventName = BetterIflytekEvent.OnError;
          break;
        default:
          eventName = BetterIflytekEvent.Unknown;
      }
      return Tuple2(eventName, details);
    });
  }

  Future<void> stopEvaluating() async {
    return _api.stopEvaluating();
  }

  Future<void> dispose() async {
    return _api.dispose();
  }
}
