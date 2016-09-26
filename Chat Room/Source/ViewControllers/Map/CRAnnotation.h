//
//  CRAnnotation.h
//  Chat Room
//
//  Created by Anatoli Tauhen on 25.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import <Foundation/Foundation.h>


@import MapKit;


@interface CRAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
