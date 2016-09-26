//
//  CRAnnotation.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 25.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRAnnotation.h"


@implementation CRAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self = [super init]) {
        _coordinate = coordinate;
    }
    
    return self;
}

@end
