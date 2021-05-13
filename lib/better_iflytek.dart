import 'dart:async';
import 'dart:io';

import 'package:better_iflytek/better_iflytek_api.dart';
import 'package:better_iflytek/better_iflytek_helper.dart';
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

  late String _pcmPath;
  late String _wavPath;

  Future<void> initSDK(String appId) async {
    String tempDir = (await getTemporaryDirectory()).path;
    _pcmPath = tempDir + "/msc/ise.pcm";
    _wavPath = tempDir + "/msc/ise.wav";

    await _api.initSDK(appId);
    await _api.setParameter({
      'language': 'en_us',
      'category': 'read_word',
      'text_encoding': 'utf-8',
      'vad_bos': 5000,
      'vad_eos': 1800,
      'sample_rate': 16000,
      'speech_timeout': -1,
      'result_level': 'plain',
      'audio_format': 'pcm',
      'ise_audio_path': Platform.isIOS ? _pcmPath.substring(tempDir.length) : _pcmPath,
    });
  }

  Future<void> setParameter(Map<String, dynamic> params) async {
    await _api.setParameter(params);
  }

  Stream<Tuple2<BetterIflytekEvent, dynamic>> getStartEvaluatingStream() {
    return _api.startEvaluatingStream.where((event) {
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

  Future<void> startEvaluating(String evaluatingText) async {
    if (await File(_pcmPath).exists()) {
      await File(_pcmPath).delete();
    }
    if (await File(_wavPath).exists()) {
      await File(_wavPath).delete();
    }

    return _api.startEvaluating(evaluatingText);
  }

  Future<void> stopEvaluating() async {
    return _api.stopEvaluating();
  }

  Future<void> dispose() async {
    return _api.dispose();
  }

  Future<String?> audioPath() async {

    if (!(await File(_pcmPath).exists())) {
      return null;
    }

    if (await File(_wavPath).exists()) {
      return _wavPath;
    }

    // pcm to wav
    await BetterIflytekHelper.pcmToWave(inputFile: _pcmPath, outputFile: _wavPath, numChannels: 1, sampleRate: 16000);

    if (await File(_wavPath).exists()) {
      return _wavPath;
    }

    return null;
  }

}
