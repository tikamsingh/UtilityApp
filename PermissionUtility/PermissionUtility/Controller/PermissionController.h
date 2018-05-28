//
//  CameraGalleryController.h
///
//  PermissionUtility
//
//  Created by Tikam on 26/05/18.
//  Copyright © 2018 Dexati. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@import Contacts;
@protocol PermissionControllerDelegate <NSObject>
@optional
- (void) mediaError:(NSString *) errorMessage errorCode:(NSInteger) code;
- (void) cameraPermissionGranted;
- (void) galleryPermissionGranted;
- (void) contactPermissionGranted;


@end

@interface PermissionController : NSObject<UIAlertViewDelegate>
{
    
}

@property (weak, nonatomic) id<PermissionControllerDelegate> delegate;

- (void)takePhotoFromCamera:(id)delegate;
- (void)takePhotoFromGallery:(id)delegate;
- (void)getAllContectsFromDevice:(id)delegate contactStore:(CNContactStore *)contactStore;

@end
