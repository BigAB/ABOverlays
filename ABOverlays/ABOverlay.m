//
//  ABOverlay.m
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-10.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABOverlay.h"

@implementation ABOverlay

#pragma mark - Property Accessors
- (void)setView:(UIView *)view
{
    _view = view;
}

#pragma mark - Class methods
+ (ABOverlay *)overlayWithView:(UIView *)view
{
    return [[self alloc] initWithView:view];
}

+ (ABOverlay *)overlayWithView:(UIView *)view modal:(BOOL)isModal
{
    return [[self alloc] initWithView:view modal:isModal];
}

#pragma mark - LifeCycle
- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (id)initWithView:(UIView *)view
{
    self = [self init];
    if (self) {
        self.view = view;
    }
    return self;
}

- (id)initWithView:(UIView *)view modal:(BOOL)isModal
{
    self = [self initWithView:view];
    if (self) {
        self.modal = isModal;
    }
    return self;
}

@end
