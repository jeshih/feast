//
//  MapViewController.h
//  testFeatures
//
//  Created by Jeffrey Shih on 12/2/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong) NSString *loc;
@property (strong) NSString *pref;

@end
