//
//  NSDate+Utils.h
//  Chat Room
//
//  Created by Anatoli Tauhen on 24.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Utils)

+ (NSDate *)dateWithServerString:(NSString *)serverString;
- (NSString *)serverString;

- (NSString *)dayOfWeek;

@end
