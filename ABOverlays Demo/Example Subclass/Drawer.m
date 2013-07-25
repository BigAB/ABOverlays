//
//  Drawer.m
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-15.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "Drawer.h"
@interface Drawer()

@property (nonatomic, assign) CGRect windowFrame;
@property (nonatomic, assign) CGRect fullFrame;

@end

@implementation Drawer

- (void)_init
{
    self.animationDuration = 0.2;
    self.animationType = AnimationTypeRevealRight;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
    [self addGestureRecognizer:tap];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)overlayWillAppear
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *mainView = mainWindow.rootViewController.view;
    CGRect drawerFrame = self.fullFrame;
    self.windowFrame = mainView.bounds;
    [UIView animateWithDuration:self.animationDuration delay:0 options:self.animationOptions animations:^{
        CGRect f = mainView.bounds;
        mainView.bounds = CGRectMake(f.origin.x + drawerFrame.size.width, f.origin.y, f.size.width, f.size.height);
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)overlayWillDisappear
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *mainView = mainWindow.rootViewController.view;
    CGRect drawerFrame = self.fullFrame;
    [UIView animateWithDuration:self.animationDuration delay:0 options:self.animationOptions animations:^{
        CGRect f = mainView.bounds;
        mainView.bounds = CGRectMake(f.origin.x - drawerFrame.size.width, f.origin.y, f.size.width, f.size.height);
    } completion:^(BOOL finished) {
        //
    }];
}

@end
