#import "NSXCTestImplementationFailureHoldingProxy.h"
#import "_XCTestCaseImplementation.h"

@interface NSXCTestImplementationFailureHoldingProxy()

@property (nonatomic, strong) _XCTestCaseImplementation *internalImplementation;

@end

@implementation NSXCTestImplementationFailureHoldingProxy

+ (_XCTestCaseImplementation *)proxyWithXCTestCaseImplementation:(_XCTestCaseImplementation *)internalImplementation
{
    NSXCTestImplementationFailureHoldingProxy *proxy = [super alloc];
    proxy.internalImplementation = internalImplementation;
    return (_XCTestCaseImplementation *)proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.internalImplementation;
}

// This will prevent test from quiting on app crash or any other test failure
- (BOOL)shouldHaltWhenReceivesControl
{
    return NO;
}

@end
