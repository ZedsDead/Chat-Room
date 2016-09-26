//
//  NSDate+Utils.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 24.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "NSDate+Utils.h"


static NSDateFormatter *dateFormatter = nil;
static NSString *const kIAServerTimeFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";


@implementation NSDate (Utils)

+ (NSDateFormatter *)dateFormatter {
    if (!dateFormatter)
        dateFormatter = [[NSDateFormatter alloc] init];
    
    return dateFormatter;
}

+ (NSDate *)dateWithServerString:(NSString *)serverString {
    NSDateFormatter *dateFormatter = [NSDate dateFormatter];
    [dateFormatter setDateFormat:kIAServerTimeFormat];
    
    return [dateFormatter dateFromString:serverString];
}

- (NSString *)serverString {
    NSDateFormatter *dateFormatter = [NSDate dateFormatter];
    [dateFormatter setDateFormat:kIAServerTimeFormat];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)dayOfWeek {
    NSDateFormatter *dateFormatter = [NSDate dateFormatter];
    [dateFormatter setDateFormat:@"EEEE"];
    
    return [dateFormatter stringFromDate:self];
}

@end
