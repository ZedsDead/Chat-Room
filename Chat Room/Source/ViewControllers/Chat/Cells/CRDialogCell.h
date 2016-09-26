//
//  CRDialogCell.h
//  Chat Room
//
//  Created by Anatoli Tauhen on 23.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CRDialogObject;

@protocol CRDialogCellDelegate;


@interface CRDialogCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topSeparator;

@property (strong, nonatomic) CRDialogObject *dialogObject;
@property (weak, nonatomic) id <CRDialogCellDelegate> delegate;

- (void)configureWithDialogObject:(CRDialogObject *)dialogObject
                         delegate:(id <CRDialogCellDelegate>)delegate __attribute__((objc_requires_super));

- (CGFloat)cellHeightForDialogObject:(CRDialogObject *)dialogObject;

@end


@protocol CRDialogCellDelegate <NSObject>

- (void)dialogCell:(CRDialogCell *)cell didUpdateWithData:(id)data;
- (void)dialogCellReceivedWrongData:(CRDialogCell *)cell;

@end
