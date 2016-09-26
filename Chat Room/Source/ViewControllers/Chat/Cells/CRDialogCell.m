//
//  CRDialogCell.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 23.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRDialogCell.h"
#import "CRDialogObject.h"


@interface CRDialogCell ()

@end


@implementation CRDialogCell

- (void)configureWithDialogObject:(CRDialogObject *)dialogObject delegate:(id <CRDialogCellDelegate>)delegate {
    self.dialogObject = dialogObject;
    self.delegate = delegate;
}

- (CGFloat)cellHeightForDialogObject:(CRDialogObject *)dialogObject {
    return 62.0f;
}

@end
