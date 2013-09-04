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

@property (nonatomic, assign) CGRect storedFrame;

@property (weak, nonatomic) IBOutlet UITextField *textArea;

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
    [self registerForKeyboardNotifications];
    self.textArea.delegate = self;
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

- (void)viewDidUnload {
    [self setTextArea:nil];
    [super viewDidUnload];
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"TextField: %@", textField.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"TextField: %@", textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@"Adam"]) {
        [self.textArea resignFirstResponder];
    }
    if ([textField.text length] > 0) {
        CGRect viewFrame, toastFrame;
        
        CGRectDivide(self.view.bounds, &toastFrame, &viewFrame, 80, CGRectMaxYEdge);
        
        
        ToastView *toast = [[ToastView alloc] initWithFrame:toastFrame];
        toast.autoresizingMask = UIViewAutoresizingNone;
        toast.animationDuration = 0.3;
        toast.animationType = AnimationTypeSlideBottom;
        __weak ToastView *_toast = toast;
        toast.viewDidAppearWithAnimationCallback = ^(UIView *view, NSDictionary *animationInfo){
            _toast.animationDuration = 0;
        };
        toast.viewDidDisappearWithAnimationCallback = ^(UIView *view, NSDictionary *animationInfo){
            _toast.animationDuration = 0.3;
        };
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldToastTapped:)];
        tap.delegate = self;
        [toast addGestureRecognizer:tap];
        
        [toast appear];
    } else {
         [self.textArea resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldToastTapped:(UIGestureRecognizer *)gestureRecognizer
{
    [self.textArea resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Keyboard notifications
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = aNotification.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.bounds;
    self.storedFrame = self.view.bounds;
    aRect.size.height -= kbSize.height;
    self.view.bounds = aRect;
    
    CGRect f = self.view.frame;
    CGRect b = self.view.bounds;
    NSLog(@"%@, %@", [NSValue valueWithCGRect:f], [NSValue valueWithCGRect:b]);
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    //scrollView.contentInset = contentInsets;
    self.view.bounds = self.storedFrame;
}
@end
