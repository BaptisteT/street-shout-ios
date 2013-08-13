//
//  NavigationViewController.m
//  street-shout-ios
//
//  Created by Bastien Beurier on 7/16/13.
//  Copyright (c) 2013 Street Shout. All rights reserved.
//

#import "NavigationViewController.h"
#import "MapRequestHandler.h"
#import "LocationUtilities.h"
#import "Shout.h"
#import "FeedTVC.h"
#import "ShoutViewController.h"

@interface NavigationViewController ()

@property (nonatomic, weak) UINavigationController *feedNavigationController;
@property (nonatomic, weak) FeedTVC *feedTVC;
@property (nonatomic, weak) MapViewController *mapViewController;

@end

@implementation NavigationViewController 

- (void)pullShoutsInZone:(NSArray *)mapBounds
{
    [self.feedTVC.activityIndicator startAnimating];
    self.feedTVC.shouts = @[@"Loading"];
    
    [MapRequestHandler pullShoutsInZone:mapBounds AndExecute:^(NSArray *shouts) {
        self.mapViewController.shouts = shouts;
        [self.feedTVC.activityIndicator stopAnimating];
        self.feedTVC.shouts = shouts;
    }];
}

- (void)shoutSelectedOnMap:(Shout *)shout
{
    if ([[self.feedNavigationController topViewController] isKindOfClass:[ShoutViewController class]]) {
        ((ShoutViewController *)[self.feedNavigationController topViewController]).shout = shout;
    } else {
        [self.feedTVC performSegueWithIdentifier:@"Show Shout" sender:shout];
    }
}

- (void)shoutDeselectedOnMap
{
    if ([[self.feedNavigationController topViewController] isKindOfClass:[ShoutViewController class]]) {
        [self.feedNavigationController popViewControllerAnimated:YES];
    }
}

- (void)shoutSelectedInFeed:(Shout *)shout
{
    self.mapViewController.preventShoutDeselection = YES;
    [self.mapViewController animateMapToLatitude:shout.lat Longitude:shout.lng WithDistance:1000];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"mapViewController"]) {
        self.mapViewController = (MapViewController *) [segue destinationViewController];
        self.mapViewController.mapVCdelegate = self;
    }
    
    if ([segueName isEqualToString: @"feedNavigationController"]) {
        self.feedNavigationController = (UINavigationController *)[segue destinationViewController];
        self.feedTVC = (FeedTVC *) [self.feedNavigationController topViewController];
        self.feedTVC.feedTVCdelegate = self;
    }
    
    if ([segueName isEqualToString: @"Create Shout Modal"]) {
        MKUserLocation *myLocation = (MKUserLocation *)sender;
        
        ((CreateShoutViewController *)[segue destinationViewController]).myLocation = myLocation;
        ((CreateShoutViewController *)[segue destinationViewController]).createShoutVCDelegate = self;
    }
}

- (void)dismissCreateShoutModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createShoutButtonClicked:(id)sender {
    MKUserLocation *myLocation = self.mapViewController.mapView.userLocation;
    
    if (myLocation && myLocation.coordinate.longitude != 0 && myLocation.coordinate.latitude != 0) {
        [self performSegueWithIdentifier:@"Create Shout Modal" sender:myLocation];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable (@"no_location_for_shout_title", @"Strings", @"comment")
                                                          message:NSLocalizedStringFromTable (@"no_location_for_shout_message", @"Strings", @"comment")
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}
- (IBAction)myLocationButtonClicked:(id)sender {
    [self.mapViewController myLocationButtonClicked];
}

- (IBAction)dezoomButtonClicked:(id)sender {
        [self.mapViewController dezoomButtonClicked];
}

@end
