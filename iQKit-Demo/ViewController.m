//
//  ViewController.m
//  iQKit-Demo
//
//  Created by Ricardo Santos on 24/04/2015.
//  Copyright (c) 2015 iQNECT. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"
#import "iQSearchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20.0, 40.0, 100.0, 50.0);
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"iQ Search" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showSuccessWithStatus:@"View Did Appear!"];
}

- (void)buttonTapped:(id)sender
{
    iQSearchViewController *searchViewController = [[iQSearchViewController alloc] init];
    [self presentViewController:searchViewController animated:YES completion:nil];
}

@end
