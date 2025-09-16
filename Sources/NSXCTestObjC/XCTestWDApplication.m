#import "XCTestWDApplication.h"
#import "XCUIApplication.h"
#import "XCTestXCAXClientProxy.h"

@implementation XCTestWDApplication

+ (NSArray<XCUIApplication *> *)activeApplications
{
    NSArray<id> *activeApplicationElements = ((NSArray*)[[XCTestXCAXClientProxy sharedClient] activeApplications]);
    NSMutableArray<XCUIApplication *> *result = [NSMutableArray array];
    
    if (activeApplicationElements.count > 0) {
        for (id applicationElement in activeApplicationElements) {
            XCUIApplication* application = [XCTestWDApplication createByPID:[[applicationElement valueForKey:@"processIdentifier"] intValue]];            
            if (nil != application) {
              [result addObject:application];
            }
        }
    }
    
    return result.copy;
}

+ (XCUIApplication*)activeApplication
{
    id activeApplicationElement = ((NSArray*)[[XCTestXCAXClientProxy sharedClient] activeApplications]).lastObject;
    
    if (!activeApplicationElement) {
        activeApplicationElement = ((XCTestXCAXClientProxy*)[XCTestXCAXClientProxy sharedClient]).systemApplication;
    }

    XCUIApplication* application = [XCTestWDApplication createByPID:[[activeApplicationElement valueForKey:@"processIdentifier"] intValue]];

    if (application.state != XCUIApplicationStateRunningForeground) {
        application = [[XCUIApplication alloc] initPrivateWithPath:nil bundleID:@"com.apple.springboard"];
    }

    [application query];
    return application;
}

+ (XCUIApplication*)createByPID:(pid_t)pid
{
    if ([XCUIApplication respondsToSelector:@selector(appWithPID:)]) {
         return [XCUIApplication appWithPID:pid];
    }
    
    if ([XCUIApplication respondsToSelector:@selector(applicationWithPID:)]) {
        return [XCUIApplication applicationWithPID:pid];
    }
    
    return [[XCTestXCAXClientProxy sharedClient] monitoredApplicationWithProcessIdentifier:pid];
}

@end
