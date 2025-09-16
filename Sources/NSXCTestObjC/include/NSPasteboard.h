//
//  NSPasteboard.h
//
//  Created by Nishith Shah on 1/9/24.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

#if !TARGET_OS_TV
@interface NSPasteboard : NSObject

/**
 Sets data to the general pasteboard

 @param data base64-encoded string containing the data chunk which is going to be written to the pasteboard
 @param type one of the possible data types to set: plaintext, url, image
 @param error If there is an error, upon return contains an NSError object that describes the problem
 @return YES if the operation was successful
 */
+ (BOOL)setData:(NSData *)data forType:(NSString *)type error:(NSError **)error;

/**
 Gets the data contained in the general pasteboard

 @param type one of the possible data types to get: plaintext, url, image
 @param error If there is an error, upon return contains an NSError object that describes the problem
 @return NSData object, containing the pasteboard content or an empty string if the pasteboard is empty.
 nil is returned if there was an error while getting the data from the pasteboard
 */
+ (nullable NSData *)dataForType:(NSString *)type error:(NSError **)error;

/**
 Gets the data contained in the general pasteboard

 @param type one of the possible data types to get: plaintext, url, image
 @param error If there is an error, upon return contains an NSError object that describes the problem
 @return NSArray object, containing the pasteboard content or an empty array if the pasteboard is empty.
 empty array is returned if there was an error while getting the data from the pasteboard
 */
+ (nullable NSArray *)arrayForType:(NSString *)type error:(NSError **)error;

@end
#endif

NS_ASSUME_NONNULL_END
