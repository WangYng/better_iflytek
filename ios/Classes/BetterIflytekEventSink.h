//
//  BetterIflytekEventSink.h
//  Pods
//
//  Created by 汪洋 on 2021/4/26.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface BetterIflytekEventSink : NSObject <FlutterStreamHandler>

@property (nonatomic, copy) FlutterEventSink event;

@end
