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
@property (strong, nonatomic) LLSimpleCamera *camera;

@property (nonatomic, weak) id<LLSimpleCameraPickerVCDelegate> delegate;

@property (nonatomic, assign) BOOL showAlbumsButton;
@property (nonatomic, assign) BOOL frontCameraYieldsMirrorImage;

@end
