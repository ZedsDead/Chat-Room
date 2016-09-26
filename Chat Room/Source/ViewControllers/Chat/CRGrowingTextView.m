//
//  CRGrowingTextView.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 25.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRGrowingTextView.h"


@interface CRGrowingTextView () {
    __weak id <CRGrowingTextViewDelegate> delegate_;
}

@property (strong, nonatomic) UILabel *placeholderLabel;

@end


@implementation CRGrowingTextView

@synthesize delegate = delegate_;

#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commonInit {
    self.textContainerInset = UIEdgeInsetsMake(4.0f, 0.0f, 4.0f, 0.0f);
    
    self.editable = YES;
    self.selectable = YES;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.directionalLockEnabled = YES;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeText:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self updatePlaceholderHidden];
    [self updatePlaceholderFrame:self.bounds];
    [self sendSubviewToBack:self.placeholderLabel];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self didChangeText:nil];
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.clipsToBounds = NO;
        _placeholderLabel.autoresizesSubviews = NO;
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = self.placeholderColor;
        _placeholderLabel.hidden = YES;
        
        [self addSubview:_placeholderLabel];
    }
    
    return _placeholderLabel;
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
}

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)updatePlaceholderHidden {
    self.placeholderLabel.hidden = self.placeholder.length == 0 || self.text.length > 0;
}

- (void)updatePlaceholderFrame:(CGRect)frame {
    CGRect placeholderFrame = UIEdgeInsetsInsetRect(frame, self.textContainerInset);
    CGFloat padding = self.textContainer.lineFragmentPadding;
    placeholderFrame.origin.x += padding;
    placeholderFrame.size.width -= padding * 2.0f;
    placeholderFrame.origin.y = self.textContainerInset.top;
    
    self.placeholderLabel.frame = placeholderFrame;
    [self.placeholderLabel sizeToFit];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (self.contentSize.height < self.maxHeight) {
        contentOffset = CGPointZero;
    } else {
        contentOffset.y += self.textContainerInset.top;
    }
    
    [super setContentOffset:contentOffset];
}

#pragma mark - Notifications

- (void)didChangeText:(NSNotification *)notification {
    [self setNeedsDisplay];
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
    CGRect newRect = (CGRect){.origin = self.frame.origin, .size = size};
    
    if ([self.delegate respondsToSelector:@selector(textView:didChangeFrame:)]) {
        [self.delegate textView:self didChangeFrame:newRect];
    }
}

@end
