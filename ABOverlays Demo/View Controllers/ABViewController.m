//
//  ABViewController.m
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-10.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABViewController.h"

@interface ABViewController ()

@property (nonatomic, strong) ToastView *alert;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) ABOverlay *popUp;
@property (nonatomic, strong) Drawer *drawer;

@end

@implementation ABViewController

- (ABOverlay *)alert
{
    if (!_alert) {
        _alert = [[ToastView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    }
    return _alert;
}

- (ABOverlay *)popUp
{
    if (!_popUp) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"popup"];
        _popUp = vc.view.subviews[0];
        _popUp.animationDuration = 0.2;
        _popUp.animationType = AnimationTypeNone;
        _popUp.modal = YES;
    }
    return _popUp;
}

- (Drawer *)drawer
{
    if (!_drawer) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"drawer"];
        _drawer = vc.view.subviews[0];
    }
    return _drawer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showAlert:(id)sender {
    [self.alert appear];
}

- (IBAction)showModal:(id)sender {
    [self.popUp appear];
}

- (IBAction)showDrawer:(id)sender {
    [self.drawer appear];
}

@end
