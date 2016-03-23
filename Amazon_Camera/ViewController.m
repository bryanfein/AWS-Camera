//
//  ViewController.m
//  Amazon_Camera
//
//  Created by Bryan Fein on 9/4/15.
//  Copyright (c) 2015 Bryan Fein. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    NSString *downloadingFilePath;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    
    
    [self downloadPhoto];
//    self.picture.image = [UIImage imageWithContentsOfFile:downloadingFilePath];

}


- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)downloadPhoto{
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    // Construct the NSURL for the download location.
    downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloaded-background.jpg"];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    // Construct the download request.
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = @"bryanfein";
    downloadRequest.key = @"background.jpg";
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    // Download the file.
    [[transferManager download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
        withBlock:^id(AWSTask *task) {
            if (task.error){
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                
                switch (task.error.code) {
            case AWSS3TransferManagerErrorCancelled:
            case AWSS3TransferManagerErrorPaused:
                break;
                                                                               
                default:
                NSLog(@"Error: %@", task.error);
                break;
            }
                } else {
                    // Unknown error.
                NSLog(@"Error: %@", task.error);
            }
        }
                                                               
            if (task.result) {
                AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
                self.picture.image = [UIImage imageWithContentsOfFile:downloadingFilePath];

                    //File downloaded successfully.
            }
            return nil;
    }];
}





@end
