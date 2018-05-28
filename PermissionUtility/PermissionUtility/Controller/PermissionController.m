//
//  CameraGalleryController.m
//
//  PermissionUtility
//
//  Created by Tikam on 26/05/18.
//  Copyright © 2018 Dexati. All rights reserved.
//
#define kSettingsMessageGallery @"Please go to Privacy and change the settings to use Gallery"
#define kSettingsMessageCamera @"Please go to Privacy and change the settings to use Camera"
#define kSettingsMessageContact @"Please go to Privacy and change the settings to use Contacts"

#define kNoCameraMessage   @"Device has no camera"


#import "PermissionController.h"
//#import "ConstantString.h"
//#import "Utility.h"
#import <Photos/Photos.h>

@implementation PermissionController

- (void)takePhotoFromCamera:(id)delegate
{
    _delegate = delegate;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        if([_delegate respondsToSelector:@selector(mediaError: errorCode:)])
        {
            [_delegate mediaError:kNoCameraMessage errorCode:0];
        }
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    // authorized
    if (authStatus == AVAuthorizationStatusAuthorized)
    {
        [self performSelector:@selector(openCamera) withObject:self afterDelay:1];
        return;
        
    }
    // denied or restricted
    else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted)
    {
        if([_delegate respondsToSelector:@selector(mediaError:errorCode:)])
        {
            [_delegate mediaError:kSettingsMessageCamera errorCode:authStatus];
        }
        return;
    }
    // not determined, we should ask peremisison
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             if (granted)
             {
                 // show not be invoked from main thread
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self performSelector:@selector(openCamera) withObject:self afterDelay:1];
                     
                 });
             }
             else
             {
                 // show not be invoked from main thread
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if([_delegate respondsToSelector:@selector(mediaError:errorCode:)])
                     {
                         [_delegate mediaError:kSettingsMessageCamera errorCode:authStatus];
                     }
                 });
             }
         }];
        
    }
    else
    {
        if([_delegate respondsToSelector:@selector(mediaError:errorCode:)])
        {
            [_delegate mediaError:kSettingsMessageCamera errorCode:authStatus];
        }
    }
    
}

- (void)takePhotoFromGallery:(id)delegate
{
    _delegate = delegate;
    PHAuthorizationStatus autorizationStatus = [PHPhotoLibrary authorizationStatus];
    // autorized
    if (autorizationStatus == PHAuthorizationStatusAuthorized)
    {
        [self openGallery];
    }
    // denied or restricted
    else if (autorizationStatus == PHAuthorizationStatusDenied || autorizationStatus == PHAuthorizationStatusRestricted)
    {
        if([_delegate respondsToSelector:@selector(mediaError:errorCode:)])
        {
            //[Utility.GetAppDelegat hideFadeView];
            [_delegate mediaError:kSettingsMessageGallery errorCode:autorizationStatus];
        }
    }
    // not determined, we should ask peremisison
    else if (autorizationStatus == PHAuthorizationStatusNotDetermined)
    {
        
        // Access has not been determined.
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                [self openGallery];
            }
            
            else {
                if([_delegate respondsToSelector:@selector(mediaError:errorCode:)])
                {
                    [_delegate mediaError:kSettingsMessageGallery errorCode:autorizationStatus];
                }            }
        }];
    }
}

-(void)getAllContectsFromDevice:(id)delegate contactStore:(CNContactStore *)contactStore{
    
    _delegate = delegate;
    
    //CNContactStore *contactsStrore = [[CNContactStore alloc] init];
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
        case CNAuthorizationStatusAuthorized:
        {
           // [self performSelector:@selector(getContact) withObject:self afterDelay:1.0 ];
            //[self getContact];
            [_delegate contactPermissionGranted];

        }
            break;
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusNotDetermined:{
            
            
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if(granted)
                {
                    //[self getContact];
                    //[self performSelector:@selector(getContact) withObject:self afterDelay:1.0 ];
                     [_delegate contactPermissionGranted];

                }
                else{
                    if([_delegate respondsToSelector:@selector(mediaError:errorCode:)])
                    {
                        [_delegate mediaError:kSettingsMessageContact errorCode:CNAuthorizationStatusRestricted];
                    }
                }
            }];
            
            break;
        }
        case CNAuthorizationStatusRestricted:
            if([_delegate respondsToSelector:@selector(mediaError:errorCode:)])
            {
                //[Utility.GetAppDelegat hideFadeView];
                [_delegate mediaError:kSettingsMessageContact errorCode:CNAuthorizationStatusRestricted];
            }
            break;
    }
}

- (void) openCamera
{
    if([_delegate respondsToSelector:@selector(cameraPermissionGranted)])
    {
        [_delegate cameraPermissionGranted];
    }
}

- (void) openGallery
{
    if([_delegate respondsToSelector:@selector(galleryPermissionGranted)])
    {
        [_delegate galleryPermissionGranted];
    }
}

-(void)getContact
{
    if([_delegate respondsToSelector:@selector(contactPermissionGranted)])
    {
        [_delegate contactPermissionGranted];
    }
}

@end
