//
//  FeastViewController.m
//  Suppr
//
//  Created by Jeffrey Shih on 11/18/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "FeastViewController.h"
#import "Constants.h"


@interface FeastViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;


@end

@implementation FeastViewController

// The CoreLocation object CLLocationManager, has a delegate method that is called
// when the location changes. This is where we will post the notification
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    self.currentLocation = newLocation;
}


- (void)setCurrentLocation:(CLLocation *)currentLocation {
    if (self.currentLocation == currentLocation) {
        return;
    }
    
    _currentLocation = currentLocation;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CurrentLocationDidChangeNotification
                                                            object:nil
                                                          userInfo:@{ LocationKey : currentLocation } ];
    });
    // ...
}
@end
