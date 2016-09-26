//
//  CRWidgetCompleteCell.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 24.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRWidgetCompleteCell.h"
#import "CRDialogObject.h"
#import "CRCommand.h"


@interface CRWidgetCompleteCell ()

@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

@end


@implementation CRWidgetCompleteCell

- (void)configureWithDialogObject:(CRDialogObject *)dialogObject delegate:(id<CRDialogCellDelegate>)delegate {
    [super configureWithDialogObject:dialogObject delegate:delegate];
    
    if (![dialogObject.command.data isKindOfClass:[NSArray class]]) {
        [self.delegate dialogCellReceivedWrongData:self];
    }
}

#pragma mark - Action section

- (IBAction)completeButtonToucehd:(UIButton *)sender {
    NSString *completion = [sender isEqual:self.yesButton] ? @"Yes" : @"No";
    
    [self.delegate dialogCell:self didUpdateWithData:@[completion]];
}

@end
