//
//  CRDialogObject.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 23.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRDialogObject.h"
#import "CRCommand.h"
#import "NSObject+GFJson.h"


@implementation CRDialogObject

- (NSDictionary *)jsonClasses {
    return @{@"command": [CRCommand class]};
}

- (NSDictionary *)objectToSend {
    NSMutableDictionary *info = [[self jsonObject] mutableCopy];
    NSMutableDictionary *commandInfo = info[@"command"];
    commandInfo[@"data"] = self.command.data;
    info[@"command"] = commandInfo;
    
    return info;
}

- (instancetype)testMessage {
    CRDialogObject *object = [[CRDialogObject alloc] init];
    object.author = self.author;
    
    NSString *message = @"";
    
    if ([self.command.type isEqualToString:kCRCommandTypeDate]) {
        message = @"Please select your appointment day";
    } else if ([self.command.type isEqualToString:kCRCommandTypeRate]) {
        message = @"Please rate your expierence";
    } else if ([self.command.type isEqualToString:kCRCommandTypeMap]) {
        message = @"Please select your current location to schedule an appointment (move the map to drop your pin on a desired location)";
    } else if ([self.command.type isEqualToString:kCRCommandTypeComplete]) {
        message = @"Would you like to schedule an appointment?";
    }
    
    object.message = message;
    
    return object;
}

@end
