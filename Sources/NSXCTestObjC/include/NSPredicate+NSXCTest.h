#import <Foundation/Foundation.h>

@interface NSPredicate (NSXCTest)

+ (instancetype)nSXCTestPredicateWithFormat:(NSString *)predicateFormat;

+ (instancetype)nSXCTestformatSearchPredicate:(NSPredicate *)input;

@end
