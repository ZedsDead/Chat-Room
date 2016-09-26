//
//  CRWidgetRateCell.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 24.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRWidgetRateCell.h"
#import "CRDialogObject.h"
#import "CRCommand.h"


@interface CRWidgetRateCell ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rateButtons;

@end


@implementation CRWidgetRateCell

- (void)configureWithDialogObject:(CRDialogObject *)dialogObject delegate:(id<CRDialogCellDelegate>)delegate {
    [super configureWithDialogObject:dialogObject delegate:delegate];
    
    if ([dialogObject.command.data isKindOfClass:[NSArray class]]) {
        NSArray *data = dialogObject.command.data;
        NSUInteger rate = [[data lastObject] unsignedIntegerValue];
        
        [self setupUserInterfaceWithRate:(rate - 1)];
    } else {
        [self.delegate dialogCellReceivedWrongData:self];
    }
}

#pragma mark - Private section

- (void)setupUserInterfaceWithRate:(NSUInteger)rate {
    for (NSUInteger index = 0; index < self.rateButtons.count; index++) {
        UIButton *rateButton = self.rateButtons[index];
        [rateButton setSelected:(index <= rate)];
    }
}

#pragma mark - Action section

- (IBAction)rateButtonTouched:(UIButton *)sender {
    NSUInteger indexOfButton = [self.rateButtons indexOfObject:sender];
    
    [self setupUserInterfaceWithRate:indexOfButton];
    
    self.dialogObject.command.data = @[@1, @(indexOfButton + 1)];
}

- (IBAction)sendRateButtonTouched:(UIButton *)sender {
    [self.delegate dialogCell:self didUpdateWithData:self.dialogObject.command.data];
}

@end
