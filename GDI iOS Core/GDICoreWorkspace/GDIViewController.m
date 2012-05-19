//
//  GDIViewController.m
//  GDICoreWorkspace
//
//  Created by Grant Davis on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIViewController.h"

@interface GDIViewController ()

- (void)testImageCrop;

@end

@implementation GDIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self testImageCrop];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)testImageCrop
{
    // test images
    UIImage *image = [UIImage imageNamed:@"diablo3.jpg"];
    UIImage *croppedImage = [image imageCroppedToRect:CGRectMake(37, 37, 426, 344)];
    
    NSLog(@"croppedImage size: %@", NSStringFromCGSize(croppedImage.size));
    
    UIImageView *originalImage = [[UIImageView alloc] initWithImage:image];
    UIImageView *croppedImageView = [[UIImageView alloc] initWithImage:croppedImage];
    
    originalImage.backgroundColor = 
    croppedImageView.backgroundColor = [UIColor colorWithRGBHex:0xff00ff];
    
    originalImage.contentMode = 
    croppedImageView.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:originalImage];
    [self.view addSubview:croppedImageView];
    originalImage.frameOrigin = CGPointMake(10, 10);
    croppedImageView.frameOrigin = CGPointMake(10, originalImage.frameBottom + 10);
}

@end
