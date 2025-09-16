//
//  NSPasteboard.m
//  NSXCTest
//
//  Created by Nishith Shah on 1/9/24.
//

#import "NSPasteboard.h"

#import <mach/mach_time.h>
#import "XCTestWDApplication.h"

#define ALERT_TIMEOUT_SEC 60
// Must not be less than FB_MONTORING_INTERVAL in FBAlertsMonitor
#define ALERT_CHECK_INTERVAL_SEC 2

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


#if !TARGET_OS_TV
@implementation NSPasteboard

+ (BOOL)setData:(NSData *)data forType:(NSString *)type error:(NSError **)error
{
  UIPasteboard *pb = UIPasteboard.generalPasteboard;
  if ([type.lowercaseString isEqualToString:@"plaintext"]) {
    pb.string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  } else {
    NSString *description = [NSString stringWithFormat:@"Unsupported content type: %@", type];
    if (error) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = description;
        *error = [NSError errorWithDomain:@"com.walmart"
                                   code:1
                               userInfo:userInfo.copy];
    }
    return NO;
  }
  return YES;
}

+ (nullable id)pasteboardContentForItem:(NSString *)item
                               instance:(UIPasteboard *)pbInstance
                                timeout:(NSTimeInterval)timeout
                                  error:(NSError **)error
{
  SEL selector = NSSelectorFromString(item);
  NSMethodSignature *methodSignature = [pbInstance methodSignatureForSelector:selector];
  if (nil == methodSignature) {
    NSString *description = [NSString stringWithFormat:@"Cannot retrieve '%@' from a UIPasteboard instance", item];
    if (error) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = description;
        *error = [NSError errorWithDomain:@"com.walmart"
                                   code:1
                               userInfo:userInfo.copy
                ];
    }
    return nil;
  }
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  [invocation setSelector:selector];
  [invocation setTarget:pbInstance];
  if (SYSTEM_VERSION_LESS_THAN(@"16.0")) {
    [invocation invoke];
    id __unsafe_unretained result;
    [invocation getReturnValue:&result];
    return result;
  }

  __block id pasteboardContent;
  dispatch_queue_t backgroundQueue = dispatch_queue_create("GetPasteboard", NULL);
  __block BOOL didFinishGetPasteboard = NO;
  dispatch_async(backgroundQueue, ^{
    [invocation invoke];
    id __unsafe_unretained result;
    [invocation getReturnValue:&result];
    pasteboardContent = result;
    didFinishGetPasteboard = YES;
  });
  uint64_t timeStarted = clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW);
  while (!didFinishGetPasteboard) {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:ALERT_CHECK_INTERVAL_SEC]];
    if (didFinishGetPasteboard) {
      break;
    }
      
      NSPredicate *alertCollectorPredicate = [NSPredicate predicateWithFormat:@"elementType IN {%lu,%lu,%lu}",
                                              XCUIElementTypeAlert, XCUIElementTypeSheet, XCUIElementTypeScrollView];
      XCUIElement *alertElement = [[[XCTestWDApplication activeApplication] descendantsMatchingType:XCUIElementTypeAny]
                                   matchingPredicate:alertCollectorPredicate].allElementsBoundByIndex.firstObject;

    if (nil != alertElement) {
        XCUIElement *allowPasteButton = alertElement.buttons[@"Allow Paste"];
        if (allowPasteButton.exists) {
            [allowPasteButton tap];
        }
    }
    uint64_t timeElapsed = clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW) - timeStarted;
    if (timeElapsed / NSEC_PER_SEC > timeout) {
      NSString *description = [NSString stringWithFormat:@"Cannot handle pasteboard alert within %@s timeout", @(timeout)];
      if (error) {
          NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
          userInfo[NSLocalizedDescriptionKey] = description;
          *error = [NSError errorWithDomain:@"com.walmart"
                                     code:1
                                 userInfo:userInfo.copy];
      }
      return nil;
    }
  }
  return pasteboardContent;
}

+ (NSData *)dataForType:(NSString *)type error:(NSError **)error
{
  UIPasteboard *pb = UIPasteboard.generalPasteboard;
  if ([type.lowercaseString isEqualToString:@"plaintext"]) {
    if (pb.hasStrings) {
      id result = [self.class pasteboardContentForItem:@"strings"
                                              instance:pb
                                               timeout:ALERT_TIMEOUT_SEC
                                                 error:error
      ];
      return nil == result
        ? nil
        : [[(NSArray *)result componentsJoinedByString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
    }
  } else {
    NSString *description = [NSString stringWithFormat:@"Unsupported content type: %@", type];
    if (error) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = description;
        *error = [NSError errorWithDomain:@"com.walmart"
                                   code:1
                               userInfo:userInfo.copy];
    }
    return nil;
  }
  return [@"" dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSArray *)arrayForType:(NSString *)type error:(NSError **)error
{
  UIPasteboard *pb = UIPasteboard.generalPasteboard;
  if ([type.lowercaseString isEqualToString:@"plaintext"]) {
    if (pb.hasStrings) {
      id result = [self.class pasteboardContentForItem:@"strings"
                                              instance:pb
                                               timeout:ALERT_TIMEOUT_SEC
                                                 error:error
      ];
      return nil == result
        ? [NSMutableArray new]
        : (NSArray *)result;
    }
  } else {
    NSString *description = [NSString stringWithFormat:@"Unsupported content type: %@", type];
    if (error) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = description;
        *error = [NSError errorWithDomain:@"com.walmart"
                                   code:1
                               userInfo:userInfo.copy];
    }
    return nil;
  }
  return [NSMutableArray new];
}

@end
#endif

