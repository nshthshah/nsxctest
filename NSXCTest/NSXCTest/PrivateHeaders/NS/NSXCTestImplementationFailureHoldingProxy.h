#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class _XCTestCaseImplementation;
/**
 Class that can be used to proxy existing _XCTestCaseImplementation and
 prevent currently running test from being terminated on any XCTest failure
 */
@interface NSXCTestImplementationFailureHoldingProxy : NSObject

/**
 Constructor for given existing _XCTestCaseImplementation instance
 */
+ (_XCTestCaseImplementation *)proxyWithXCTestCaseImplementation:(_XCTestCaseImplementation *)internalImplementation;

@end

NS_ASSUME_NONNULL_END
