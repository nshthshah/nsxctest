//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "CDStructures.h"
#import "XCDebugLogDelegate-Protocol.h"
#import "XCTestDriverInterface-Protocol.h"
#import "XCTestManager_TestsInterface-Protocol.h"
#import "XCTestManager_IDEInterface-Protocol.h"
#import "XCTestManager_ManagerInterface-Protocol.h"

@class DTXConnection, NSMutableArray, NSString, NSUUID, NSXPCConnection, XCTestConfiguration, XCTestSuite;

@interface XCTestDriver : NSObject <XCTestManager_TestsInterface, XCTestDriverInterface, XCDebugLogDelegate>
{
    XCTestConfiguration *_testConfiguration;
    NSObject *_queue;
    NSMutableArray *_debugMessageBuffer;
    int _debugMessageBufferOverflow;
}
@property int debugMessageBufferOverflow; // @synthesize debugMessageBufferOverflow=_debugMessageBufferOverflow;
@property(retain) NSMutableArray *debugMessageBuffer; // @synthesize debugMessageBuffer=_debugMessageBuffer;
@property(retain) NSObject *queue; // @synthesize queue=_queue;
@property(readonly) XCTestConfiguration *testConfiguration; // @synthesize testConfiguration=_testConfiguration;

+ (instancetype)sharedTestDriver;

- (void)runTestConfiguration:(id)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)runTestSuite:(id)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)reportStallOnMainThreadInTestCase:(id)arg1 method:(id)arg2 file:(id)arg3 line:(unsigned long long)arg4;
- (BOOL)runTestsAndReturnError:(id *)arg1;
- (id)_readyIDESession:(id *)arg1;
- (int)_connectedSocketForIDESession:(id *)arg1;
- (void)logDebugMessage:(id)arg1;
- (id)initWithTestConfiguration:(id)arg1;

// Removed with iOS 10.3
@property(readonly) id <XCTestManager_ManagerInterface> managerProxy;

@end
