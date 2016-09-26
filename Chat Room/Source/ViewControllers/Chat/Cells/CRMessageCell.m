//
//  CRMessageCell.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 22.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRMessageCell.h"
#import "CRDialogObject.h"


@interface CRMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTraillingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *placeholderLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *placeholderTraillingConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageLabelBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *placeholderTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *authorLabelBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *authorLabelheightConstraint;


@end


@implementation CRMessageCell

- (void)configureWithDialogObject:(CRDialogObject *)dialogObject delegate:(id<CRDialogCellDelegate>)delegate {
    [super configureWithDialogObject:dialogObject delegate:delegate];
    
    self.messageLabel.text = dialogObject.message;
    self.authorLabel.text = dialogObject.author;
}

- (CGFloat)cellHeightForDialogObject:(CRDialogObject *)dialogObject {
    NSString *text = dialogObject.message;
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - self.placeholderLeadingConstraint.constant - self.placeholderTraillingConstraint.constant - self.messageLabelLeadingConstraint.constant - self.messageLabelTraillingConstraint.constant;
    
    CGSize boundingSize = CGSizeMake(width, CGFLOAT_MAX);
    
    CGSize size = [text boundingRectWithSize:boundingSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.messageLabel.font,
                                               NSForegroundColorAttributeName: self.messageLabel.textColor}
                                     context:nil].size;
    
    size.height++;
    
    return MAX(size.height, 16.0f) + self.placeholderTopConstraint.constant + self.messageLabelTopConstraint.constant + self.messageLabelBottomConstraint.constant + self.authorLabelBottomConstraint.constant + self.authorLabelheightConstraint.constant;
}

@end
