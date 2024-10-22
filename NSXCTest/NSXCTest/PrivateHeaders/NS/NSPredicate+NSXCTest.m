#import "NSPredicate+NSXCTest.h"

@implementation NSPredicate(NSXCTest)

+ (instancetype)nSXCTestPredicateWithFormat:(NSString *)predicateFormat
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:nil];
    NSPredicate *hackPredicate = [NSPredicate predicateWithFormat:self.forceResolvePredicateString];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, hackPredicate]];
}

+ (NSString *)forceResolvePredicateString
{
    return @"1 == 1 or identifier == 0 or frame == 0 or value == 0 or title == 0 or label == 0 or elementType == 0 or enabled == 0 or placeholderValue == 0";
}

+ (instancetype)nSXCTestPredicateWithPredicate:(NSPredicate *)original comparisonModifier:(NSPredicate *(^)(NSComparisonPredicate *))comparisonModifier
{
    if ([original isKindOfClass:NSCompoundPredicate.class]) {
        NSCompoundPredicate *compPred = (NSCompoundPredicate *)original;
        NSMutableArray *predicates = [NSMutableArray array];
        for (NSPredicate *predicate in [compPred subpredicates]) {
            if ([predicate.predicateFormat.lowercaseString isEqualToString:NSPredicate.forceResolvePredicateString.lowercaseString]) {
                // Do not translete this predicate
                [predicates addObject:predicate];
                continue;
            }
            NSPredicate *newPredicate = [self.class nSXCTestPredicateWithPredicate:predicate comparisonModifier:comparisonModifier];
            if (nil != newPredicate) {
                [predicates addObject:newPredicate];
            }
        }
        return [[NSCompoundPredicate alloc] initWithType:compPred.compoundPredicateType
                                           subpredicates:predicates];
    }
    if ([original isKindOfClass:NSComparisonPredicate.class]) {
        return comparisonModifier((NSComparisonPredicate *)original);
    }
    return original;
}

+ (instancetype)nSXCTestformatSearchPredicate:(NSPredicate *)input
{
    return [self.class nSXCTestPredicateWithPredicate:input comparisonModifier:^NSPredicate *(NSComparisonPredicate *cp) {
        return [NSComparisonPredicate predicateWithLeftExpression:[cp leftExpression]
                                                  rightExpression:[cp rightExpression]
                                                         modifier:cp.comparisonPredicateModifier
                                                             type:cp.predicateOperatorType
                                                          options:cp.options];
    }];
}

@end
