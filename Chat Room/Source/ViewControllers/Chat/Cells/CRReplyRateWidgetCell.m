//
//  CRReplyRateWidgetCell.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 25.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRReplyRateWidgetCell.h"
#import "CRDialogObject.h"
#import "CRCommand.h"


@interface CRReplyRateWidgetCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end


@implementation CRReplyRateWidgetCell

- (void)configureWithDialogObject:(CRDialogObject *)dialogObject delegate:(id<CRDialogCellDelegate>)delegate {
    [super configureWithDialogObject:dialogObject delegate:delegate];
    
    self.authorLabel.text = dialogObject.author;
    
    CRCommand *command = dialogObject.command;
    
    if (command.complete.boolValue && [command.data isKindOfClass:[NSArray class]]) {
        [self setupUserInterfaceWithRate:([[command.data lastObject] unsignedIntegerValue] - 1)];
    }
}

#pragma mark - Private section

- (void)setupUserInterfaceWithRate:(NSUInteger)rate {
    for (NSUInteger index = 0; index < self.stars.count; index++) {
        UIImageView *star = self.stars[index];
        star.highlighted = index <= rate;
    }
}

@end
