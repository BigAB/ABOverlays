//
//  MyModalViewController.m
//  ABOverlays
//
//  Created by Adam Barrett on 2013-07-11.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "MyModalViewController.h"

@interface MyModalViewController ()

@property (weak, nonatomic) IBOutlet ABOverlay *popUpView;

@end

@implementation MyModalViewController
- (IBAction)popUpButtonPressed:(UIButton *)sender {
    [self.popUpView disappear];
}

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

- (void)viewDidUnload {
    [self setPopUpView:nil];
    [super viewDidUnload];
}
@end
