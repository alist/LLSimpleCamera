//
//  HomeViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "LLSimpleCameraPickerVC.h"
#import "ViewUtils.h"
#import "ViewUtils.h"
#import "HTImageMirrorBehavior.h"

@interface LLSimpleCameraPickerVC ()
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *albumsButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) HTImageMirrorBehavior * imageMirrorBehavior;
@end

@implementation LLSimpleCameraPickerVC

-(LLSimpleCamera*)camera{
    if (_camera == nil){
        _camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto andPosition:CameraPositionBack];
    }
    return _camera;
}

-(HTImageMirrorBehavior*)imageMirrorBehavior{
    if (_imageMirrorBehavior == nil){
        _imageMirrorBehavior = [[HTImageMirrorBehavior alloc] init];
        _imageMirrorBehavior.mirrorHorrizontal  = true;
        _imageMirrorBehavior.activateWhenReady  = true;
    }
    return _imageMirrorBehavior;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = YES;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        //HTLog(@"Device changed. %@",device);
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == CameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        HTLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodePermission) {
                if(weakSelf.errorLabel)
                    [weakSelf.errorLabel removeFromSuperview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    // ----- camera buttons -------- //
    
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-off.png"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-on.png"] forState:UIControlStateSelected];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    // button to toggle camera positions
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(0, 0, 29.0f + 20.0f, 22.0f + 20.0f);
    [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(0, 0, 40,40);
    [self.closeButton setImage:[UIImage imageNamed:@"camera-close.png"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];

    if (self.showAlbumsButton){
        self.albumsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.albumsButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        self.albumsButton.frame = CGRectMake(0, 0, 35+self.albumsButton.imageEdgeInsets.left+self.albumsButton.imageEdgeInsets.right,35+self.albumsButton.imageEdgeInsets.top+self.albumsButton.imageEdgeInsets.bottom);
        [self.albumsButton setImage:[UIImage imageNamed:@"camera-gallery"] forState:UIControlStateNormal];
        [self.albumsButton addTarget:self action:@selector(albumsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.albumsButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // stop the camera
    [self.camera stop];
}

/* camera button methods */

- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (void)closeButtonPressed:(UIButton*)button{
    [self.delegate imagePickerControllerDidCancel:self];
}

- (void)albumsButtonPressed:(UIButton*)button{
    [self.delegate imagePickerControllerAlbumsPressed:self];
}

- (void)flashButtonPressed:(UIButton *)button {
    
    if(self.camera.flash == CameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:CameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:CameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
        }
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    
    // capture
    __weak LLSimpleCameraPickerVC * wSelf = self;
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            // we should stop the camera, since we don't need it anymore. We will open a new vc.
            // this very important, otherwise you may experience memory crashes
            [camera stop];
            
            UIImage * outputImage = image;
            if (wSelf.frontCameraYieldsMirrorImage && camera.position == CameraPositionFront){
                [self.imageMirrorBehavior setImage:image];
                outputImage = self.imageMirrorBehavior.outputImage;
            }
            
            // show the image
            [wSelf.delegate imagePickerController:wSelf didFinishPickingMediaWithInfo:@{UIImagePickerControllerOriginalImage: outputImage}];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}

/* other lifecycle methods */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.contentBounds;
    
    self.snapButton.center = self.view.contentCenter;
    self.snapButton.bottom = self.view.height - 15;
    
    self.flashButton.center = self.view.contentCenter;
    self.flashButton.top = 5.0f;
    
    self.switchButton.top = 5.0f;
    self.switchButton.right = self.view.width - 5.0f;
    
    self.closeButton.center = self.switchButton.center;
    self.closeButton.left = 5.0f;

    self.albumsButton.center = (CGPoint){ceil(self.snapButton.center.x/2), self.snapButton.center.y};
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
