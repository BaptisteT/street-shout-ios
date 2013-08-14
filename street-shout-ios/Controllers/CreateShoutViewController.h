//
//  CreateShoutViewController.h
//  street-shout-ios
//
//  Created by Bastien Beurier on 7/24/13.
//  Copyright (c) 2013 Street Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RefineShoutLocationViewController.h"

@protocol CreateShoutViewControllerDelegate;

@interface CreateShoutViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, RefineShoutLocationViewControllerDelegate>

@property (weak, nonatomic) id <CreateShoutViewControllerDelegate> createShoutVCDelegate;
@property (strong, nonatomic) CLLocation *myLocation;
@property (strong, nonatomic) CLLocation *shoutLocation;

@end

@protocol CreateShoutViewControllerDelegate

- (void)dismissCreateShoutModal;

@end