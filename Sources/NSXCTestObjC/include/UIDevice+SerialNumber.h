//
//  UIDevice+SerialNumber.h
//
//  Created by Nishith Shah on 07/02/20.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS
#import <UIKit/UIDevice.h>

@interface UIDevice (SerialNumber)

@property (nonatomic, readonly) NSString *serialNumber;

@end
#endif
