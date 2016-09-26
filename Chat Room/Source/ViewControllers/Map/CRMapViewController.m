//
//  CRMapViewController.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 25.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRMapViewController.h"
#import "CRDialogObject.h"
#import "CRCommand.h"
#import "CRAnnotation.h"


@interface CRMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *footerHeightConstraint;

@end


@implementation CRMapViewController

#pragma mark - View lifecicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUserInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private section

- (void)setupUserInterface {
    NSDictionary *data = self.dialogObject.command.data;
    
    NSString *latitudeString = data[@"lat"];
    NSString *longitudeString = data[@"lng"];
    
    CLLocationDegrees latitude = [latitudeString floatValue];
    CLLocationDegrees longitude = [longitudeString floatValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    [self.mapView setRegion:region];
    
    if (self.dialogObject.command.complete.boolValue) {
        self.pinImageView.hidden = YES;
        self.footerHeightConstraint.constant = 0.0f;
        
        CRAnnotation *annotation = [[CRAnnotation alloc] initWithCoordinate:coordinate];
        [self.mapView addAnnotation:annotation];
    }
}

#pragma mark - MKMapViewDelegate

- (IBAction)sendButtonTouched:(UIButton *)sender {
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    
    [self.delegate mapViewController:self didUpdateCoordinate:coordinate];
}

@end
