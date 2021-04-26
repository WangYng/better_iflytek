package com.wangyng.better_iflytek;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.iflytek.cloud.EvaluatorListener;
import com.iflytek.cloud.EvaluatorResult;
import com.iflytek.cloud.SpeechError;
import com.iflytek.cloud.SpeechEvaluator;
import com.iflytek.cloud.SpeechUtility;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

/**
 * BetterIflytekPlugin
 */
public class BetterIflytekPlugin implements FlutterPlugin, BetterIflytekApi {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        BetterIflytekApi.setup(binding.getBinaryMessenger(), this, binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        BetterIflytekApi.setup(binding.getBinaryMessenger(), null, null);
    }

    private SpeechEvaluator speechEvaluator;

    @Override
    public void initSDK(Context context, String secret) {
        SpeechUtility.createUtility(context, secret);
        speechEvaluator = SpeechEvaluator.createEvaluator(context, null);
    }

    @Override
    public void setParameter(String key, String value) {
        if (speechEvaluator != null) {
            speechEvaluator.setParameter(key, value);
        }
    }

    @Override
    public void startEvaluating(String evaluatingText, QueuingEventSink eventSink) {
        if (speechEvaluator != null) {
            speechEvaluator.startEvaluating(evaluatingText, null, new EvaluatorListener() {
                @Override
                public void onVolumeChanged(int i, byte[] bytes) {
                    HashMap<String, Object> event = new HashMap<>();
                    event.put("name", "onVolumeChanged");
                    event.put("details", i);
                    eventSink.success(event);
                }

                @Override
                public void onBeginOfSpeech() { // 可以开始语音输入
                    HashMap<String, Object> event = new HashMap<>();
                    event.put("name", "onBeginOfSpeech");
                    eventSink.success(event);
                }

                @Override
                public void onEndOfSpeech() {// 不再接受语音输入
                    HashMap<String, Object> event = new HashMap<>();
                    event.put("name", "onEndOfSpeech");
                    eventSink.success(event);
                }

                @Override
                public void onResult(EvaluatorResult evaluatorResult, boolean isLast) {
                    HashMap<String, Object> event = new HashMap<>();
                    event.put("name", "onResult");
                    event.put("details", evaluatorResult.getResultString());
                    eventSink.success(event);
                }

                @Override
                public void onError(SpeechError speechError) {
                    HashMap<String, Object> event = new HashMap<>();
                    event.put("name", "onError");
                    event.put("details", speechError.getErrorCode() + " " + speechError.getErrorDescription());
                    eventSink.success(event);
                }

                @Override
                public void onEvent(int i, int i1, int i2, Bundle bundle) {

                }
            });
        }
    }

    @Override
    public void stopEvaluating() {
        if (speechEvaluator != null) {
            if (speechEvaluator.isEvaluating()) {
                speechEvaluator.stopEvaluating();
            }
        }
    }

    @Override
    public void dispose() {
        if (speechEvaluator != null) {
            speechEvaluator.destroy();
            speechEvaluator = null;
        }
    }
}
