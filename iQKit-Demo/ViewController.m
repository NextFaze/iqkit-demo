//
//  ViewController.m
//  iQKit-Demo
//
//  Created by Ricardo Santos on 24/04/2015.
//  Copyright (c) 2015 iQNECT. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"
#import "iQKit.h"

@interface ViewController () <iQScannerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat padding = 20.0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(padding, 20.0 + padding, self.view.frame.size.width - 2*padding, 44.0);
    button.backgroundColor = [UIColor lightGrayColor];
    button.layer.cornerRadius = 4.0;
    [button setTitle:@"iQ Search" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)buttonTapped:(id)sender
{
    iQScannerViewController *scannerViewController = [[iQScannerViewController alloc] init];
    scannerViewController.continuousScanEnabled = NO;
    scannerViewController.delegate = self;
    
    [self presentViewController:scannerViewController animated:YES completion:nil];
}

#pragma mark - iQScannerViewControllerDelegate

- (void)scannerViewController:(iQScannerViewController *)scannerViewController didScanBarcode:(AVMetadataMachineReadableCodeObject *)barcode
{
    NSLog(@"Barcode: %@", barcode);
}

- (void)scannerViewController:(iQScannerViewController *)scannerViewController didCaptureImageData:(NSData *)imageData
{
    NSLog(@"Image data: %@", imageData);
}

- (void)scannerViewController:(iQScannerViewController *)scannerViewController didLoadSearchResponse:(iQAPISearchResponse *)searchResponse
{
    NSLog(@"Search response: %@", searchResponse);
}

- (void)scannerViewControllerDidCancel:(iQScannerViewController *)scannerViewController
{
    NSLog(@"Cancelled");
    [scannerViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
