//
//  ABOverlay.m
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-10.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABOverlay.h"

@interface ABOverlay ()

@property (nonatomic, strong) UIWindow *mainWindow;
@property (nonatomic, strong) GhostWindow *overlayWindow;

@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) CGRect storedBGFrame;
@property (nonatomic, assign) CGRect windowFrame;
@property (nonatomic, assign) CGRect fullframe;

@property (nonatomic, strong) UITapGestureRecognizer *modalTap;

- (void)overlayWillAppear;
- (void)overlayDidAppear;
- (void)overlayWillDisappear;
- (void)overlayDidDisappear;

@end

@implementation ABOverlay {}

@synthesize modalBackgroundColor = _modalBackgroundColor;

#pragma mark - Property Accessors
- (UIWindow *)mainWindow
{
    if (!_mainWindow) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        if (!window || ![window isMemberOfClass:[UIWindow class]] || window == self.overlayWindow) window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        
        _mainWindow = window;
    }
    
    return _mainWindow;
}


- (GhostWindow *)overlayWindow
{
    if (!_overlayWindow) {
        _overlayWindow = [GhostWindow new];
        _overlayWindow.windowLevel = self.windowLevel;
        
        ABBaseViewController *vc = [ABBaseViewController new];
        
        // FIXME: iOS 6 Method
        vc.wantsFullScreenLayout = self.wantsFullScreenLayout;
        
        _overlayWindow.rootViewController = vc;
        
        if (self.modal) {
            vc.view.backgroundColor = self.modalBackgroundColor;
        } else {
            vc.view.backgroundColor = [UIColor clearColor];
        }
        
        _overlayWindow.touchable = self.modal;
        [self addModalTapGesture:(_overlayWindow.touchable && self.closeOnModalTap)];
    }
    
    return _overlayWindow;
}


- (void)setModal:(BOOL)modal
{
    if (_modal != modal) {
        _modal = modal;
        self.overlayWindow.touchable = modal;
        
        if (modal) {
            self.modalBackgroundView.backgroundColor = self.modalBackgroundColor;
        } else {
            self.modalBackgroundView.backgroundColor = [UIColor clearColor];
        }
    }
}


- (void)setCloseOnModalTap:(BOOL)closeOnModalTap
{
    if (_closeOnModalTap != closeOnModalTap) {
        _closeOnModalTap = closeOnModalTap;
        [self addModalTapGesture:closeOnModalTap];
    }
}


- (UIColor *)modalBackgroundColor
{
    if (!_modalBackgroundColor) {
        _modalBackgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    
    return _modalBackgroundColor;
}


- (void)setModalBackgroundColor:(UIColor *)modalBackgroundColor
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


- (UITapGestureRecognizer *)modalTap
{
    if (!_modalTap) {
        _modalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ghostWindowTapped:)];
    }
    
    return _modalTap;
}


#pragma mark - Modal Stuff
- (void)ghostWindowTapped:(UIGestureRecognizer *)gestureRecognizer
{
    [self disappear];
}


- (void)addModalTapGesture:(BOOL)add
{
    if (add) {
        if (![self.modalBackgroundView.gestureRecognizers containsObject:self.modalTap]) {
            [self.modalBackgroundView addGestureRecognizer:self.modalTap];
        }
    } else {
        if ([self.modalBackgroundView.gestureRecognizers containsObject:self.modalTap]) {
            [self.modalBackgroundView removeGestureRecognizer:self.modalTap];
            self.modalTap = nil;
        }
    }
}


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
    
    // Get the original window so we can make it key again for the keyboard or other interaction.
    UIWindow *originalWindow = [UIApplication sharedApplication].keyWindow;
    [self.overlayWindow makeKeyAndVisible];
    [originalWindow makeKeyWindow];
    
    [super appear];
}


- (void)adjustFrameForOverlayWindow
{
    //TODO: This method has to do with switching orientation while reusing the same
    // ovelay. This may be eliminated with proper use of the childViewController methods
    // addChildViewController and what not
    
    if (CGRectEqualToRect(self.originalFrame, CGRectZero) ) {
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
    self.mainWindow = nil;
    self.overlayWindow.hidden = YES;
    self.overlayWindow = nil;
    [self overlayDidDisappear];
}


- (void)overlayWillAppear
{
}                          // for subclassing


- (void)overlayDidAppear
{
}                          // for subclassing


- (void)overlayWillDisappear
{
}                          // for subclassing


- (void)overlayDidDisappear
{
}                          // for subclassing


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
- (UIViewController *)firstAvailableUIViewController
{
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}


- (id)traverseResponderChainForUIViewController
{
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
    }
    
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *views = [NSArray array];
    
    UIViewController *viewController = self.rootViewController;
    
    while (viewController) {
        views = [views arrayByAddingObjectsFromArray:self.rootViewController.view.subviews];
        
        if (self.touchable) {
            views = [views arrayByAddingObject:viewController.view];
        }
        
        viewController = viewController.presentedViewController;
    }
    
    for (UIView *view in views) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) return YES;
    }
    
    return NO;
}


@end



@interface ABBaseViewController ()

@end

@implementation ABBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)mainWindowRootViewController;
{
    UIWindow *window = [UIApplication sharedApplication].windows.count ? [[UIApplication sharedApplication].windows firstObject] : nil;
    
    return window.rootViewController;
}


- (BOOL)shouldAutorotate
{
    return [[self mainWindowRootViewController] shouldAutorotate];
}


- (NSUInteger)supportedInterfaceOrientations
{
    return [[self mainWindowRootViewController] supportedInterfaceOrientations];
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self mainWindowRootViewController] preferredInterfaceOrientationForPresentation];
}


@end
