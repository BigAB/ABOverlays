//
//  ABOverlay.m
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-10.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABOverlay.h"

@interface ABOverlay()

@property (nonatomic, strong) UIWindow *mainWindow;
@property (nonatomic, strong) GhostWindow *overlayWindow;

@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) CGRect storedBGFrame;
@property (nonatomic, assign) CGRect windowFrame;
@property (nonatomic, assign) CGRect fullframe;

- (void)overlayWillAppear;
- (void)overlayDidAppear;
- (void)overlayWillDisappear;
- (void)overlayDidDisappear;

@end

@implementation ABOverlay {}

#pragma mark - Property Accessors
- (UIWindow *)mainWindow
{
    if (!_mainWindow) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window || ![window isMemberOfClass:[UIWindow class]] || window == self.overlayWindow)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        _mainWindow = window;
    }
    return _mainWindow;
}

- (GhostWindow *)overlayWindow
{
    if (!_overlayWindow) {
        _overlayWindow = [GhostWindow new];
        UIViewController *vc = [UIViewController new];
        
        _overlayWindow.rootViewController = vc;
        if (self.modal)  {
            vc.view.backgroundColor = self.modalBackgroundColor;
        } else {
            vc.view.backgroundColor = [UIColor clearColor];
        }
        _overlayWindow.touchable = self.modal;
    }
    return _overlayWindow;
}

- (void)setModal:(BOOL)modal
{
    if (_modal != modal) {
        _modal = modal;
        self.overlayWindow.touchable = modal;
        if (modal)  {
            self.modalBackgroundView.backgroundColor = self.modalBackgroundColor;
        } else {
            self.modalBackgroundView.backgroundColor = [UIColor clearColor];
        }
    }
}

- (UIColor *)modalBackgroundColor
{
    if (!_modalBackgroundColor) {
        _modalBackgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    return _modalBackgroundColor;
}

- (void)setmodalBackgroundColor:(UIColor *)modalBackgroundColor
{
    if (_modalBackgroundColor != modalBackgroundColor) {
        _modalBackgroundColor = modalBackgroundColor;
        if (self.modal) {
            self.modalBackgroundView.backgroundColor = modalBackgroundColor;
        }
    }
}

- (UIView *)modalBackgroundView
{
    return self.overlayWindow.rootViewController.view;
}

#pragma mark - Class methods


#pragma mark - LifeCycle
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    UIViewController *vc = [self firstAvailableUIViewController];
    if (vc && vc != self.overlayWindow.rootViewController) {
        self.storedViewController = vc;
    }
}

#pragma mark - Appearing and Disappearing
- (void)appear
{
    if (!self.hidden) return;
    
    [self adjustFrameForOverlayWindow];
    
    [self.modalBackgroundView addSubview:self];
    [self.overlayWindow makeKeyAndVisible];
    
    [super appear];
}

- (void)adjustFrameForOverlayWindow
{
    if ( CGRectEqualToRect(self.originalFrame, CGRectZero) ) {
        self.originalFrame = self.frame;
        self.storedBGFrame = self.modalBackgroundView.frame;
    } else {
        CGRect f = self.originalFrame;
        CGRect s = self.storedBGFrame;
        CGRect b = self.modalBackgroundView.frame;
        
        CGFloat x = s.origin.x - b.origin.x;
        CGFloat height = b.size.height - s.size.height;
        
        CGRect final = CGRectMake(f.origin.x + x, f.origin.y, f.size.width, f.size.height + height);
        self.frame = final;
    }
}

- (void)viewWillAppearWithAnimation:(AnimationType)animationType
{
    [self overlayWillAppear];
}

- (void)viewDidAppearWithAnimation:(AnimationType)animationType
{
    [self overlayDidAppear];
}

- (void)viewWillDisappearWithAnimation:(AnimationType)animationType
{
    [self overlayWillDisappear];
}

- (void)viewDidDisappearWithAnimation:(AnimationType)animationType
{
    UIWindow *windowToReturnTo = [self getWindowToReturnTo];
    [windowToReturnTo makeKeyAndVisible];
    self.mainWindow = nil;
    self.overlayWindow = nil;
    [self overlayDidDisappear];
}

- (UIWindow *)getWindowToReturnTo
{
    UIWindow *window;
    
    __block GhostWindow *myWindow = self.overlayWindow;
    NSArray *ghostWindows = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id windowObj, NSDictionary *bindings) {
        return ([windowObj class] == [GhostWindow class] && windowObj != myWindow);
    }]];
    
    window = [ghostWindows lastObject];
    
    return window ?: self.mainWindow;
}

- (void)overlayWillAppear {} // for subclassing
- (void)overlayDidAppear{} // for subclassing
- (void)overlayWillDisappear{} // for subclassing
- (void)overlayDidDisappear{} // for subclassing

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self disappear];
}

@end

#pragma mark - UIView+FindViewController.h
#pragma mark -
// ---------------------------------------------------
//  UIView+FindViewController.h
//
//  This Great Idea by Phil M
//  http://stackoverflow.com/questions/1340434/get-to-uiviewcontroller-from-uiview-on-iphone
// ---------------------------------------------------

@implementation UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end

#pragma mark - GhostWindow
#pragma mark -
// ---------------------------------------------------
//  GhostWindow
//
//  Created by Adam Barrett on 13-05-23.
//  http://bigab.mit-license.org/
//
//  A window that can be invisible and touchless
// ---------------------------------------------------
@implementation GhostWindow

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelNormal;
    }
    return self;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSArray *views = self.rootViewController.view.subviews;
    if (self.touchable) {
        views = [views arrayByAddingObject:self.rootViewController.view];
    }
    for (UIView *view in views) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}
@end