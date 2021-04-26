#import "BetterIflytekPlugin.h"
#import <iflyMSC/iflyMSC.h>
#import "BetterIflytekEventSink.h"

@interface BetterIflytekPlugin () 

@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;

@property (nonatomic, strong) BetterIflytekEventSink *eventSink;

@end

@interface BetterIflytekPlugin (IFlySpeechEvaluatorDelegate) <IFlySpeechEvaluatorDelegate>

@end

@implementation BetterIflytekPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    BetterIflytekPlugin* instance = [[BetterIflytekPlugin alloc] init];
    [BetterIflytekApi setup:[registrar messenger] api:instance];
}

// 初始化SDK
- (void)initSDK:(NSString *)appId {
    [IFlySpeechUtility createUtility:appId];
    self.iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
}

// 设置参数
- (void)setParameter:(NSString *)key value:(NSString *)value {
    [self.iFlySpeechEvaluator setParameter:value forKey:key];
}

// 开始评测
- (void)startEvaluating:(NSString *)evaluatingText eventSink:(BetterIflytekEventSink *)eventSink {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableData *buffer= [NSMutableData dataWithData:[evaluatingText dataUsingEncoding:encoding]];
    
    self.eventSink = eventSink;
    self.iFlySpeechEvaluator.delegate = self;
    [self.iFlySpeechEvaluator startListening:buffer params:nil];
    
}

// 结束评测
- (void)stopEvaluating {
    [self.iFlySpeechEvaluator stopListening];
}

// 销毁环境
- (void)dispose {
    [self.iFlySpeechEvaluator cancel];
    self.iFlySpeechEvaluator.delegate = nil;
}

@end

@implementation BetterIflytekPlugin (IFlySpeechEvaluatorDelegate)


- (void)onBeginOfSpeech {
    NSMutableDictionary<NSString *, NSObject *> *event = [NSMutableDictionary new];
    event[@"name"] = @"onBeginOfSpeech";
    
    if (self.eventSink.event != NULL) {
        self.eventSink.event(event);
    }
}

- (void)onCancel {
    
}

- (void)onCompleted:(IFlySpeechError *)errorCode {
    NSMutableDictionary<NSString *, NSObject *> *event = [NSMutableDictionary new];
    event[@"name"] = @"onError";
    event[@"details"] = [NSString stringWithFormat:@"%d %@", errorCode.errorCode, errorCode.description];
    
    if (self.eventSink.event != NULL) {
        self.eventSink.event(event);
    }
}

- (void)onEndOfSpeech {
    NSMutableDictionary<NSString *, NSObject *> *event = [NSMutableDictionary new];
    event[@"name"] = @"onEndOfSpeech";
    
    if (self.eventSink.event != NULL) {
        self.eventSink.event(event);
    }
}

- (void)onResults:(NSData *)results isLast:(BOOL)isLast {
    
    NSString* strResults = nil;
    
    BOOL isUTF8 = [[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
    NSStringEncoding encoding;
    if(isUTF8){
        encoding = NSUTF8StringEncoding;
    }else{
        encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    
    strResults=[[NSString alloc] initWithBytes:[results bytes] length:[results length] encoding:encoding];
    
    NSMutableDictionary<NSString *, NSObject *> *event = [NSMutableDictionary new];
    event[@"name"] = @"onResult";
    event[@"details"] = strResults;
    
    if (self.eventSink.event != NULL) {
        self.eventSink.event(event);
    }
}

- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
    NSMutableDictionary<NSString *, NSObject *> *event = [NSMutableDictionary new];
    event[@"name"] = @"onVolumeChanged";
    event[@"details"] = @(volume);
    
    if (self.eventSink.event != NULL) {
        self.eventSink.event(event);
    }
}

@end
