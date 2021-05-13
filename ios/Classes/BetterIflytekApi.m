//
//  BetterIflytekApi.m
//  Pods
//
//  Created by 汪洋 on 2021/4/25.
//

#import "BetterIflytekApi.h"

@implementation BetterIflytekApi

+ (void)setup:(NSObject<FlutterBinaryMessenger> *)messenger api:(id<BetterIflytekApiDelegate>)api {
    
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_iflytek.initSDK" binaryMessenger:messenger];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *params = message;
                    NSString *appId = params[@"appId"];
                    [api initSDK:appId];
                    
                    wrapped[@"result"] = nil;
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_iflytek.setParameter" binaryMessenger:messenger];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *params = message;
                    for (NSString *key in params.allKeys) {
                        [api setParameter:key value:params[key]];
                    }
                    
                    wrapped[@"result"] = nil;
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    
    {
        FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.wangyng.better_iflytek/evaluatorListenerEvent" binaryMessenger:messenger];
        BetterIflytekEventSink *eventSink = [[BetterIflytekEventSink alloc] init];
        
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_iflytek.startEvaluating" binaryMessenger:messenger];

        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {

                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *params = message;
                    NSString *evaluatingText = params[@"evaluatingText"];
                    [api startEvaluating:evaluatingText eventSink:eventSink];
                    
                    wrapped[@"result"] = nil;
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
            [eventChannel setStreamHandler:eventSink];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_iflytek.stopEvaluating" binaryMessenger:messenger];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {

                [api stopEvaluating];
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                wrapped[@"result"] = nil;
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_iflytek.dispose" binaryMessenger:messenger];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                
                [api dispose];
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                wrapped[@"result"] = nil;
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
}

@end
