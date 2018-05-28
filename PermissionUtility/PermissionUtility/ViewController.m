//
//  ViewController.m
//  PermissionUtility
//  Created by Tikam on 26/05/18.
//  Copyright © 2018 Dexati. All rights reserved.
//

#import "ViewController.h"
#import "PermissionController.h"
#import "FullImageViewController.h"
#import <ContactsUI/ContactsUI.h>
@import Contacts;

@interface ViewController ()<UIImagePickerControllerDelegate,CNContactViewControllerDelegate, CNContactPickerDelegate,UINavigationControllerDelegate,PermissionControllerDelegate>
{
    PermissionController *permission;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    permission = [[PermissionController alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

-(IBAction)selectPhotoFromCamera
{
    [permission takePhotoFromCamera:self];
}
-(IBAction)selectPhotoFromGallery
{
   [permission takePhotoFromGallery:self];
}
-(IBAction)selectContactFromDevice
{
}
#pragma mark -Delegate for permission Call Back
- (void) mediaError:(NSString *) errorMessage errorCode:(NSInteger) code
{
//    UIAlertController *alertController =
//
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                          message:errorMessage
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles: nil];
//    [myAlertView show];
    
}
- (void) cameraPermissionGranted
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void) galleryPermissionGranted
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)contactPermissionGranted{
    // Create a new picker
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    // Select property to pick
    [contactPicker setDisplayedPropertyKeys:[[NSArray alloc] initWithObjects:CNContactEmailAddressesKey, nil] ];
    [contactPicker setPredicateForEnablingContact:[NSPredicate predicateWithFormat:@"emailAddresses.@count > 0"]];
    [contactPicker setPredicateForSelectionOfContact:[NSPredicate predicateWithFormat:@"emailAddresses.@count == 1"]];
    // Respond to selection
    contactPicker.delegate = self;
    // Display picker
    [self presentViewController:contactPicker animated:YES completion:nil];
    
}
//- (void) contactPermissionGranted
//{
//
//}
#pragma mark - Delegate for Image Picker
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *pickerImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FullImageViewController *roomController = [storyboard instantiateViewControllerWithIdentifier:@"fullScreen"];
        
        [roomController setSelectedImage:pickerImage];
        [self.navigationController pushViewController: roomController animated:YES];

       // [self.navigationController pushViewController:fullView animated:YES];

        
    }];
   // [fullView setSelectedImage:pickerImage];
    
}
@end
