//
//  CRCommand.h
//  Chat Room
//
//  Created by Anatoli Tauhen on 21.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *const kCRCommandTypeDate = @"date";
static NSString *const kCRCommandTypeMap = @"map";
static NSString *const kCRCommandTypeRate = @"rate";
static NSString *const kCRCommandTypeComplete = @"complete";


@interface CRCommand : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *complete;
@property (strong, nonatomic) id data;

@end
