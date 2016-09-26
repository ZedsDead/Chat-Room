//
//  CRDialogObject.h
//  Chat Room
//
//  Created by Anatoli Tauhen on 23.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CRCommand;


@interface CRDialogObject : NSObject

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) CRCommand *command;

- (NSDictionary *)objectToSend;

- (instancetype)testMessage;

@end
