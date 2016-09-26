//
//  CRMapViewController.h
//  Chat Room
//
//  Created by Anatoli Tauhen on 25.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import <UIKit/UIKit.h>


@import MapKit;

@class CRDialogObject;

@protocol CRMapViewControllerDelegate;


@interface CRMapViewController : UIViewController

@property (weak, nonatomic) id <CRMapViewControllerDelegate> delegate;
@property (strong, nonatomic) CRDialogObject *dialogObject;

@end


@protocol CRMapViewControllerDelegate <NSObject>

- (void)mapViewController:(CRMapViewController *)viewController didUpdateCoordinate:(CLLocationCoordinate2D)coordinate;

@end
