# better_iflytek

A iFLYTEK SDK for flutter.

## Install Started

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  better_iflytek: ^0.0.4
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
```

## Feature
- [x] ISE

## Others

> [科大迅飞 iOS SDK 文档](https://www.xfyun.cn/doc/Ise/iOS-SDK.html) <br/>
> [科大迅飞 Android SDK 文档](https://www.xfyun.cn/doc/Ise/Android-SDK.html) <br/>

#### Part of the parameter description.
| 参数名称 | 名称 | 说明 |
| --- | --- | --- |
| language | 语言区域 | zh_cn：中文<br/>en_us：英文 |
| category  | 评测题型 | read_syllable（单字，汉语专有）<br/>read_word（词语）<br/>read_sentence（句子）<br/>read_chapter（篇章） |
| text_encoding  | 文本编码 | 输入文本编码格式<br/>固定utf-8 |
| vad_bos  | 前端点检测 | 开始录入音频后，音频前面部分最长静音时长<br/>取值范围[0,10000ms] |
| vad_eos  | 后端点检测 | 开始录入音频后，音频后面部分最长静音时长<br/>取值范围[0,10000ms] |
| sample_rate  | 采样率 | 8000 或者 16000 |
| speech_timeout  | 语音输入超时时间 | 语音输入超时时间<br>默认30000 |
| result_level  | 评测结果等级 | complete（完整）<br/>plain（简单） |
| audio_format  | 保存音频格式 | 保存音频格式支持<br/>pcm（iOS，Android）<br/>wav（Android） |
| ise_audio_path  | 评测录音保存路径 | 评测录音保存完整路径（Android）<br/> 评测录音保存子路径，子路径拼接在Library/cache后面（iOS）|


