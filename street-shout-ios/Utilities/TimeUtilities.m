//
//  TimeUtilities.m
//  street-shout-ios
//
//  Created by Bastien Beurier on 7/23/13.
//  Copyright (c) 2013 Street Shout. All rights reserved.
//

#import "TimeUtilities.h"
#import "Constants.h"

#define ONE_MINUTE 60
#define ONE_HOUR (60 * ONE_MINUTE)
#define ONE_DAY (24 * ONE_HOUR)
#define ONE_WEEK (7 * ONE_DAY)
#define ONE_YEAR (52 * ONE_WEEK)

@implementation TimeUtilities

+ (NSTimeInterval)getShoutAge:(NSString *)dateCreated
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Universal"]];
    NSDate *shoutDate = [dateFormatter dateFromString:dateCreated];
    return -[shoutDate timeIntervalSinceNow];
}

+ (NSArray *)ageToStrings:(NSTimeInterval)age
{
    if (age > 0) {
        NSUInteger hours = ((NSUInteger)age) / ONE_HOUR;
        if (hours > 23) {
            NSUInteger days = ((NSUInteger)age) / ONE_DAY;
            if (days > 6) {
                NSUInteger weeks = ((NSUInteger)age) / ONE_WEEK;
                if (weeks > 51) {
                    NSUInteger years = ((NSUInteger)age) / ONE_YEAR;
                    if (years == 1) {
                        return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)years], NSLocalizedStringFromTable (@"year", @"Strings", @"comment"), nil];
                    } else {
                        return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)years], NSLocalizedStringFromTable (@"years", @"Strings", @"comment"), nil];
                    }
                } else {
                    if (weeks == 1) {
                        return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)weeks], NSLocalizedStringFromTable (@"week", @"Strings", @"comment"), nil];
                    } else {
                        return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)weeks], NSLocalizedStringFromTable (@"weeks", @"Strings", @"comment"), nil];
                    }
                }
            } else {
                if (days == 1) {
                    return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)days], NSLocalizedStringFromTable (@"day", @"Strings", @"comment"), nil];
                } else {
                    return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)days], NSLocalizedStringFromTable (@"days", @"Strings", @"comment"), nil];
                }
            }
        } else if (hours > 1) {
            return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)hours], NSLocalizedStringFromTable (@"hours", @"Strings", @"comment"), nil];
        } else if (hours == 1) {
            return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)hours], NSLocalizedStringFromTable (@"hour", @"Strings", @"comment"), nil];
        } else {
            NSUInteger minutes = ((NSUInteger)age) / ONE_MINUTE;
            if (minutes > 1) {
                return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)minutes], NSLocalizedStringFromTable (@"minutes", @"Strings", @"comment"), nil];
            } else if (minutes == 1) {
                return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lu", (unsigned long)minutes], NSLocalizedStringFromTable (@"minute", @"Strings", @"comment"), nil];
            } else {
                return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", 0], NSLocalizedStringFromTable (@"minute", @"Strings", @"comment"), nil];
            }
        }
        
    } else {
        return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", 0], NSLocalizedStringFromTable (@"minute", @"Strings", @"comment"), nil];
    }
}

+ (NSArray *)ageToShortStrings:(NSTimeInterval)age
{
    NSArray *array = [self ageToStrings:age];
    return [[NSArray alloc] initWithObjects:array.firstObject,[(NSString *)array.lastObject substringToIndex:1],nil];
}

@end
