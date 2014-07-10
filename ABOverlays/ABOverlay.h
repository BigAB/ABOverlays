//
//  ABOverlay.h
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-10.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "ABAppearingView.h"

@interface ABOverlay : ABAppearingView

@property (nonatomic, assign) BOOL modal;
@property (nonatomic, assign) UIWindowLevel windowLevel;
@property (nonatomic, strong) UIColor *modalBackgroundColor;
@property (nonatomic, readonly) UIView *modalBackgroundView;
@property (nonatomic, assign) BOOL closeOnModalTap;
@property (nonatomic, assign) BOOL wantsFullScreenLayout;

@property (nonatomic, strong) UIViewController *storedViewController;

@end


// ---------------------------------------------------
//  UIView+FindViewController.h
//
//  This Great Idea by Phil M
//  http://stackoverflow.com/questions/1340434/get-to-uiviewcontroller-from-uiview-on-iphone
// ---------------------------------------------------
#pragma mark - UIView+FindViewController
@interface UIView (FindUIViewController)
- (UIViewController *)firstAvailableUIViewController;
- (id)traverseResponderChainForUIViewController;
@end

// ---------------------------------------------------
//  GhostWindow.h
//
//  Created by Adam Barrett on 13-05-23.
//  http://bigab.mit-license.org/
//  A window that can be invisible and touchless
// ---------------------------------------------------
@interface GhostWindow : UIWindow
@property (nonatomic, assign) BOOL touchable;
@end


@interface ABBaseViewController : UIViewController
@end
