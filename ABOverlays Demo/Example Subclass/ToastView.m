//
//  ToastView.m
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-11.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ToastView.h"

@implementation ToastView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIViewAutoresizing mask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.animationDuration = 0.5;
        self.animationType = AnimationTypeSlideTop;
        self.autoresizingMask = mask;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastTap:)];
        [self addGestureRecognizer:tap];
        
        YIInnerShadowView *innerShadowView = [[YIInnerShadowView alloc] initWithFrame:self.bounds];
        innerShadowView.shadowRadius = 5;
        innerShadowView.shadowMask = YIInnerShadowMaskAll;
        innerShadowView.shadowColor = [UIColor colorWithRed:158.0/255.0 green:163.0/255.0 blue:172.0/255.0 alpha:1];
        innerShadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:innerShadowView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.text = @"This is an alert!";
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = mask;
        [self addSubview:label];
        
        UIView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Alert-Icon"]];
        icon.frame = CGRectMake(30, 30, 20, 20);
        icon.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:icon];

    }
    return self;
}

- (void)handleToastTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self disappear];
}

- (void)overlayDidAppear
{
    [self performSelector:@selector(delayedDisappear) withObject:nil afterDelay:2];
}

- (void)overlayWillDisappear
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedDisappear) object:nil];
}

- (void)delayedDisappear
{
    [self disappear];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
