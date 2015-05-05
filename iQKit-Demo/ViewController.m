//
//  ViewController.m
//  iQKit-Demo
//
//  Created by Ricardo Santos on 24/04/2015.
//  Copyright (c) 2015 iQNECT. All rights reserved.
//

#import "ViewController.h"
#import "iQKit.h"
#import "SVProgressHUD.h"
#import "SVWebViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController () <iQScannerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat padding = 20.0;
    
    UIButton *scannerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scannerButton.frame = CGRectMake(padding, 20.0 + padding, self.view.frame.size.width - 2*padding, 44.0);
    scannerButton.backgroundColor = [UIColor lightGrayColor];
    scannerButton.layer.cornerRadius = 4.0;
    [scannerButton setTitle:@"Open Scanner" forState:UIControlStateNormal];
    [scannerButton addTarget:self action:@selector(scannerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scannerButton];
    
    UIButton *galleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    galleryButton.frame = CGRectMake(padding, scannerButton.bottom + padding, scannerButton.width, scannerButton.height);
    galleryButton.backgroundColor = [UIColor lightGrayColor];
    galleryButton.layer.cornerRadius = 4.0;
    [galleryButton setTitle:@"Image Picker" forState:UIControlStateNormal];
    [galleryButton addTarget:self action:@selector(galleryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:galleryButton];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(padding, galleryButton.bottom + padding, scannerButton.width, scannerButton.height);
    textField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    textField.layer.cornerRadius = 4.0;
    textField.placeholder = @"Enter Keyword";
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:textField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)scannerButtonTapped:(id)sender
{
    iQScannerViewController *scannerViewController = [[iQScannerViewController alloc] init];
    scannerViewController.delegate = self;
    
    [self presentViewController:scannerViewController animated:YES completion:nil];
}

- (void)galleryButtonTapped:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 

- (void)processSearchResponse:(iQAPISearchResponse *)searchResponse
{
    NSLog(@"Search response: %@", searchResponse);

    if (searchResponse.payload) {
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:searchResponse.payload];
        [self presentViewController:webViewController animated:YES completion:nil];
    }
}

#pragma mark - iQScannerViewControllerDelegate

- (void)scannerViewController:(iQScannerViewController *)scannerViewController didScanBarcode:(AVMetadataMachineReadableCodeObject *)barcode
{
    NSLog(@"Barcode: %@", barcode);
}

- (void)scannerViewController:(iQScannerViewController *)scannerViewController didLoadSearchResponse:(iQAPISearchResponse *)searchResponse
{
    [scannerViewController dismissViewControllerAnimated:YES completion:^{
        [self processSearchResponse:searchResponse];
    }];
}

- (void)scannerViewControllerDidCancel:(iQScannerViewController *)scannerViewController
{
    [scannerViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[iQAPISearchRequest requestWithImage:image] runWithCompletionHandler:^(iQAPISearchResponse *response) {
            [SVProgressHUD dismiss];
            [self processSearchResponse:response];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[iQAPISearchRequest requestWithKeyword:textField.text] runWithCompletionHandler:^(iQAPISearchResponse *response) {
        [SVProgressHUD dismiss];
        [self processSearchResponse:response];
    }];
    return YES;
}

@end
