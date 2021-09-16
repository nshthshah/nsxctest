#import "NSRadioPreferences.h"
#import "RadiosPreferences.h"

@implementation NSRadioPreferences

+ (void)setAirplaneMode:(bool)arg1 {
    RadiosPreferences *radiosPreferences = [[RadiosPreferences alloc] init];
    [radiosPreferences setAirplaneMode:arg1];
    [radiosPreferences synchronize];
}

@end
