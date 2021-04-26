//
//  BetterIflytekApi.h
//  Pods
//
//  Created by 汪洋 on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "BetterIflytekEventSink.h"

@protocol BetterIflytekApiDelegate <NSObject>

// 初始化SDK
- (void)initSDK:(NSString *)appId;

// 设置参数
- (void)setParameter:(NSString *)key value:(NSString *)value;

// 开始评测
- (void)startEvaluating:(NSString *)evaluatingText eventSink:(BetterIflytekEventSink *)eventSink;

// 结束评测
- (void)stopEvaluating;

// 销毁环境
- (void)dispose;

@end

@interface BetterIflytekApi : NSObject

+ (void)setup:(NSObject<FlutterBinaryMessenger> *)messenger api:(id<BetterIflytekApiDelegate>)api;

@end

