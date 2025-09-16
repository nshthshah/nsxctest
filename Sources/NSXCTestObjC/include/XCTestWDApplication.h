#import <Foundation/Foundation.h>
#import "XCUIApplication.h"

@interface XCTestWDApplication : NSObject

+ (NSArray<XCUIApplication *> *)activeApplications;

+ (XCUIApplication*)activeApplication;

+ (XCUIApplication*)createByPID:(pid_t)pid;

@end
