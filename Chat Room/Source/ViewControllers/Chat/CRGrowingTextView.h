//
//  CRGrowingTextView.h
//  Chat Room
//
//  Created by Anatoli Tauhen on 25.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CRGrowingTextView;


@protocol CRGrowingTextViewDelegate <UITextViewDelegate>

@optional
- (void)textView:(CRGrowingTextView *)textView didChangeFrame:(CGRect)newFrame;

@end


@interface CRGrowingTextView : UITextView

@property (weak, nonatomic) id <CRGrowingTextViewDelegate> delegate;

@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) UIColor *placeholderColor;

@property (nonatomic) NSUInteger maxHeight;

@end
