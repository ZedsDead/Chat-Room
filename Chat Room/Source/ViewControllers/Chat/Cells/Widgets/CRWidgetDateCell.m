//
//  CRWidgetDateCell.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 24.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRWidgetDateCell.h"
#import "CRDialogObject.h"
#import "CRCommand.h"
#import "NSDate+Utils.h"


@interface CRWidgetDateCell ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dateButtons;
@property (strong, nonatomic) NSMutableArray *dates;

@end


@implementation CRWidgetDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIButton *button in self.dateButtons) {
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 0.5;
    }
}

- (void)configureWithDialogObject:(CRDialogObject *)dialogObject delegate:(id<CRDialogCellDelegate>)delegate {
    [super configureWithDialogObject:dialogObject delegate:delegate];
    
    [self.dates removeAllObjects];
    
    if ([dialogObject.command.data isKindOfClass:[NSString class]]) {
        NSString *dateString = dialogObject.command.data;
        NSDate *date = [NSDate dateWithServerString:dateString];
        
        [self setupUserInterfaceWithDate:date];
    } else {
        [self.delegate dialogCellReceivedWrongData:self];
    }
}

#pragma mark - Private section

- (void)setupUserInterfaceWithDate:(NSDate *)date {
    if (!date) {
        return;
    }
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger index = 0;
    
    do {
        if ([calendar isDateInWeekend:date]) {
            date = [calendar dateByAddingComponents:components toDate:date options:kNilOptions];
            continue;
        }
        
        [self.dates addObject:date];
        
        NSString *dayOfWeek = [date dayOfWeek];
        UIButton *button = self.dateButtons[index];
        [button setTitle:[dayOfWeek capitalizedString] forState:UIControlStateNormal];
        
        date = [calendar dateByAddingComponents:components toDate:date options:kNilOptions];
        
        index++;
    } while (index < self.dateButtons.count);
}

#pragma mark - Lazy loading

- (NSMutableArray *)dates {
    if (!_dates) {
        _dates = [[NSMutableArray alloc] initWithCapacity:self.dateButtons.count];
    }
    
    return _dates;
}

#pragma mark - Action section

- (IBAction)dateButtonTouched:(UIButton *)sender {
    NSUInteger indexOfButton = [self.dateButtons indexOfObject:sender];
    NSDate *selectedDate = self.dates[indexOfButton];
    
    [self.delegate dialogCell:self didUpdateWithData:[selectedDate serverString]];
}

@end
