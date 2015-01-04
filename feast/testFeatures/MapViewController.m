//
//  MapViewController.m
//  testFeatures
//
//  Created by Jeffrey Shih on 12/2/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property (strong, nonatomic) MKMapItem * mapitem;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;

    
    _mapView.showsUserLocation = YES;

   // [_mapView removeAnnotations:[_mapView annotations]];

    [self performSearch];

    [self zoomMapViewToFitAnnotationsWithAnimation:YES];
    

}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   // [self.mapitem openInMapsWithLaunchOptions:nil];

}



- (void) performSearch {
    MKLocalSearchRequest *request =
    [[MKLocalSearchRequest alloc] init];
    if ([self.loc isEqualToString:@""]){
        request.naturalLanguageQuery = self.pref;
    }
    else{
        request.naturalLanguageQuery = self.loc;
    }
    MKCoordinateRegion userRegion = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, 2000, 100);
    request.region = userRegion;
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;

    
    _matchingItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search =
    [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                [_matchingItems addObject:item];
                NSMutableArray *annotations = [NSMutableArray array];
                
                [annotations addObject:item.placemark];
                
                self.mapitem = [[MKMapItem alloc] initWithPlacemark:item.placemark];
                [self.mapitem setName:self.loc];
                [_mapView addAnnotations:annotations];

            }
    }];
}


// I found the following method on Brian Reiter's Thoughtful Code blog: brianreiter.org
// I have adapted it for my purposes.
- (void)zoomMapViewToFitAnnotationsWithAnimation:(BOOL)animated
{
    NSArray *annotations = self.mapView.annotations;
    int count = [self.mapView.annotations count];
    if (count == 0) {
        return; //bail if no annotations
    }
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    
    //load points C array by converting coordinates to points
    for (int i=0; i<count; i++) {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta *= 1.1;
    region.span.longitudeDelta *= 1.1;
    
    //but padding can't be bigger than the world
    if (region.span.latitudeDelta > 360) {
        region.span.latitudeDelta = 360;
    }
    if (region.span.longitudeDelta > 360) {
        region.span.longitudeDelta = 360;
    }
    
    //and don't zoom in stupid-close on small samples
    if (region.span.latitudeDelta < 0.015) {
        region.span.latitudeDelta = 0.015;
    }
    if (region.span.longitudeDelta < 0.015) {
        region.span.longitudeDelta = 0.015;
    }
    
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if (count == 1)
    {
        region.span.latitudeDelta = 0.015;
        region.span.longitudeDelta = 0.015;
    }
    
    [self.mapView setRegion:region animated:animated];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView* annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                       reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = view.annotation;
    CLLocationCoordinate2D coordinate = [annotation coordinate];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapitem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapitem.name = annotation.title;
    [mapitem openInMapsWithLaunchOptions:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
