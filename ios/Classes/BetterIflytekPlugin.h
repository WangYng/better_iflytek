#import <Flutter/Flutter.h>
#import "BetterIflytekApi.h"
#import <iflyMSC/iflyMSC.h>

@interface BetterIflytekPlugin : NSObject<BetterIflytekApiDelegate>

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end
