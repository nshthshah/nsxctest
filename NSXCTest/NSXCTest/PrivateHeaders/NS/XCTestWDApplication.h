#import <Foundation/Foundation.h>
#import "XCUIApplication.h"

@interface XCTestWDApplication : NSObject

+ (XCUIApplication*)activeApplication;

+ (XCUIApplication*)createByPID:(pid_t)pid;

@end
