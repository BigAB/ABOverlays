//
//  ABOverlay.h
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-10.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABOverlay : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) BOOL modal;

+ (ABOverlay *)overlayWithView:(UIView *)view;
+ (ABOverlay *)overlayWithView:(UIView *)view modal:(BOOL)isModal;

- (id)initWithView:(UIView *)view;
- (id)initWithView:(UIView *)view modal:(BOOL)isModal;

@end
