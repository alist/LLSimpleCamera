//
//  HomeViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"


@class LLSimpleCameraPickerVC;
@protocol LLSimpleCameraPickerVCDelegate<NSObject>

- (void)imagePickerController:(LLSimpleCameraPickerVC *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(LLSimpleCameraPickerVC *)picker;

- (void)imagePickerControllerAlbumsPressed:(LLSimpleCameraPickerVC *)picker;

@end

@interface LLSimpleCameraPickerVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *snapButton;
@property (strong, nonatomic) IBOutlet UIButton *switchButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *albumsButton;
@property (strong, nonatomic) IBOutlet UIButton *flashButton;

- (IBAction)snapButtonPressed:(id)sender;
- (IBAction)switchButtonPressed:(id)sender;
- (IBAction)flashButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)albumsButtonPressed:(id)sender;

@property (strong, nonatomic) LLSimpleCamera *camera;

@property (nonatomic, weak) IBOutlet id<LLSimpleCameraPickerVCDelegate> delegate;

@property (nonatomic, assign) BOOL showAlbumsButton;
@property (nonatomic, assign) BOOL frontCameraYieldsMirrorImage;

@end
