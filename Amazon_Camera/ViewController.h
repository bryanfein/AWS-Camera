//
//  ViewController.h
//  Amazon_Camera
//
//  Created by Bryan Fein on 9/4/15.
//  Copyright (c) 2015 Bryan Fein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>



@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(id)sender;

- (IBAction)selectPhoto:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *picture;

@end

