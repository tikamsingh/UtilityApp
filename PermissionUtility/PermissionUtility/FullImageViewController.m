//
//  FullImageViewController.m
//  PermissionUtility
//
//  Created by Tikam on 26/05/18.
//  Copyright © 2018 Dexati. All rights reserved.
//

#import "FullImageViewController.h"
#import <UIkit/UIKit.h>
@implementation FullImageViewController
{
    IBOutlet UIImageView *fullImage;
}

- (void)viewDidLoad
{
    fullImage.image = self.selectedImage;
    [super viewDidLoad];
}
@end
