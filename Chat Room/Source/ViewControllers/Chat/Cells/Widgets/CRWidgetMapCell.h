//
//  CRWidgetMapCell.h
//  Chat Room
//
//  Created by Anatoli Tauhen on 24.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRWidgetCell.h"


@import MapKit;

@class CRWidgetMapCell;


@protocol CRWidgetMapCellDelegate <CRDialogCellDelegate>

- (void)widgetMapCellDidTouched:(CRWidgetMapCell *)cell;

@end


@interface CRWidgetMapCell : CRWidgetCell

@property (weak, nonatomic) id <CRWidgetMapCellDelegate> delegate;

@end
