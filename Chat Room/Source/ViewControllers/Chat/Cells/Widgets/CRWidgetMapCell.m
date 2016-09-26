//
//  CRWidgetMapCell.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 24.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRWidgetMapCell.h"
#import "CRDialogObject.h"
#import "CRCommand.h"
#import "CRAnnotation.h"


#define CRColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0f]


@interface CRWidgetMapCell () {
    __weak id <CRWidgetMapCellDelegate> delegate_;
}

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end


@implementation CRWidgetMapCell

@synthesize delegate = delegate_;

- (void)configureWithDialogObject:(CRDialogObject *)dialogObject delegate:(id<CRDialogCellDelegate>)delegate {
    [super configureWithDialogObject:dialogObject delegate:delegate];
    
    if (self.dialogObject.command.complete) {
        self.authorLabel.text = self.dialogObject.author;
    }
    
    if ([self.dialogObject.command.data isKindOfClass:[NSDictionary class]]) {
        [self setupUserInterfaceWithData:self.dialogObject.command.data];
    } else {
        [self.delegate dialogCellReceivedWrongData:self];
    }
}

- (CGFloat)cellHeightForDialogObject:(CRDialogObject *)dialogObject {
    return 150.0f;
}

#pragma mark - Private section

- (void)setupUserInterfaceWithData:(NSDictionary *)data {
    NSString *latitudeString = data[@"lat"];
    NSString *longitudeString = data[@"lng"];
    
    if (!latitudeString || !longitudeString) {
        [self.delegate dialogCellReceivedWrongData:self];
        return;
    }
    
    self.mapImageView.layer.borderColor = CRColorFromRGB(0x26a9e0).CGColor;
    
    CLLocationDegrees latitude = [latitudeString floatValue];
    CLLocationDegrees longitude = [longitudeString floatValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05f, 0.05f);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [self cellHeightForDialogObject:nil]);
    
    __weak typeof(self) welf = self;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        UIImage *image = snapshot.image;
        
        if (image) {
            UIImage *annotationImage = [UIImage imageNamed:@"pin"];
            
            UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
            
            [image drawAtPoint:CGPointZero];

            CGPoint coordPoint = [snapshot pointForCoordinate:coordinate];
            coordPoint.x -= annotationImage.size.width / 2.0f;
            coordPoint.y -= annotationImage.size.height;
            
            [annotationImage drawAtPoint:coordPoint];
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            [welf.mapImageView setImage:image];
        }
    }];
}

#pragma mark - Action section

- (IBAction)mapButtonTouched:(UIButton *)sender {
    [self.delegate widgetMapCellDidTouched:self];
}

@end
