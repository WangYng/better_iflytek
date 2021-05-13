package com.wangyng.better_iflytek;

import android.content.Context;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public interface BetterIflytekApi {

    // 初始化SDK
    void initSDK(Context context, String appId);

    // 设置参数
    void setParameter(String key, String value);

    // 开始评测
    void startEvaluating(String evaluatingText, BetterIflytekEventSink eventSink);

    // 结束评测
    void stopEvaluating();

    // 销毁环境
    void dispose();

    static void setup(BinaryMessenger binaryMessenger, BetterIflytekApi api, Context context) {
        { // initSDK
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_iflytek.initSDK", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> params = (HashMap<String, Object>) message;
                        String appId = params.get("appId").toString();
                        api.initSDK(context, appId);

                        wrapped.put("result", null);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // setParameter
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_iflytek.setParameter", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> params = (HashMap<String, Object>) message;
                        for (String key : params.keySet()) {
                            api.setParameter(key, params.get(key).toString());
                        }

                        wrapped.put("result", null);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // startEvaluating
            EventChannel eventChannel = new EventChannel(binaryMessenger, "com.wangyng.better_iflytek/evaluatorListenerEvent");
            BetterIflytekEventSink eventSink = new BetterIflytekEventSink();
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_iflytek.startEvaluating", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> params = (HashMap<String, Object>) message;
                        String evaluatingText = params.get("evaluatingText").toString();
                        api.startEvaluating(evaluatingText, eventSink);

                        wrapped.put("result", null);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
                eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSink.event = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        eventSink.event = null;
                    }
                });
            } else {
                channel.setMessageHandler(null);
                eventChannel.setStreamHandler(null);
            }
        }
        { // stopEvaluating
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_iflytek.stopEvaluating", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    api.stopEvaluating();

                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    wrapped.put("result", null);
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // dispose
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_iflytek.dispose", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    api.dispose();

                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    wrapped.put("result", null);
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
    }

    static HashMap<String, Object> wrapError(Exception exception) {
        HashMap<String, Object> errorMap = new HashMap<>();
        errorMap.put("message", exception.toString());
        errorMap.put("code", null);
        errorMap.put("details", null);
        return errorMap;
    }
}
