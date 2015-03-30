//
//  ViewController.m
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/26/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "ViewController.h"
#import "StreetEasyManager.h"

#define kStartingDistance 2000
#define kUnknownLocation @"Unknown Location"

@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property BOOL isNeighborhoodInformationShowing;
@property CGFloat neighborhoodInformationViewOffset;

@property CLLocationManager *locationManager;
@end

@implementation ViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNeighborhoodInformationShowing = false;
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    self.neighborhoodInformationViewOffset = (screen.size.width * (29/50.0f)) - (screen.size.width * (25/200.0f));
    [self.neighborhoodInformationView setTransform:CGAffineTransformMakeTranslation(0, self.neighborhoodInformationViewOffset)];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeNeighborhoodView:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.neighborhoodInformationView addGestureRecognizer:swipeGesture];
    
    [self.neighborhoodInformationView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNeighborhoodLabel:)]];
    [self.neighborhoodInformationView setUserInteractionEnabled:false];
    
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    
    [self.mapView setDelegate:self];
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark Location Managers

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self updateWithCoordinate:location.coordinate];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self updateWithCoordinate:userLocation.coordinate];
}

- (void)updateWithCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, kStartingDistance, kStartingDistance);
    
    [self.mapView setRegion:region];
    
    [[StreetEasyManager sharedManager] getAreaByLocation:coordinate withCompletionBlock:^(NSError *error, NSDictionary *dict) {
        if (!error && dict) {
            NSString *name = dict[@"name"];
            // Only update the sales/rentals information and neighborhood polygon when the neighborhood has changed
            if (![self.neighborhoodLabel.text isEqualToString:name]) {
                [self.neighborhoodInformationView setUserInteractionEnabled:true];
                [self.neighborhoodLabel setText:name];
                [self updateSalesAndRentalInformationForNeighborhood:name];
                [self getGeometryForNeighborhood:name];
            }
        } else {
            [self.neighborhoodLabel setText:kUnknownLocation];
            [self.mapView removeOverlays:self.mapView.overlays];
            [self.neighborhoodInformationView setUserInteractionEnabled:false];
        }
    }];
}

#pragma mark Gesture Recognizers

- (void)tapNeighborhoodLabel:(UITapGestureRecognizer*)tap {
    [UIView animateWithDuration:.75 delay:0 usingSpringWithDamping:.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (!self.isNeighborhoodInformationShowing) {
            [self.neighborhoodInformationView setTransform:CGAffineTransformIdentity];
        } else {
            [self.neighborhoodInformationView setTransform:CGAffineTransformMakeTranslation(0, self.neighborhoodInformationViewOffset)];
        }
    } completion:^(BOOL finished){
        self.isNeighborhoodInformationShowing = !self.isNeighborhoodInformationShowing;
    }];
}

- (void)swipeNeighborhoodView:(UISwipeGestureRecognizer*)swipe {
    [UIView animateWithDuration:.75 delay:0 usingSpringWithDamping:.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.isNeighborhoodInformationShowing) {
            [self.neighborhoodInformationView setTransform:CGAffineTransformMakeTranslation(0, self.neighborhoodInformationViewOffset)];
        }
    } completion:^(BOOL finished){
        self.isNeighborhoodInformationShowing = !self.isNeighborhoodInformationShowing;
    }];
}

- (IBAction)filterButtonSelected:(id)sender {
    UIViewController *filterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterNavigationController"];
    [self presentViewController:filterViewController animated:YES completion:nil];
}

- (void)filterOptionsUpdated {
    if (![self.neighborhoodLabel.text isEqualToString:kUnknownLocation]) {
        [self updateSalesAndRentalInformationForNeighborhood:self.neighborhoodLabel.text];
    }
}

#pragma mark Sales/Rentals Information Updaters

- (void)updateSalesAndRentalInformationForNeighborhood:(NSString*)neighborhood {
    [[StreetEasyManager sharedManager] getSalesByArea:neighborhood withCompletionBlock:^(NSError *error, NSDictionary *data) {
        if (!error && data) {
            NSNumber *count = data[@"listing_count"];
            NSNumber *medianPrice = data[@"median_price"];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            [self.salesCountLabel setText:[NSString stringWithFormat:@"%@",count]];
            [self.salesPriceLabel setText:[NSString stringWithFormat:@"$%@",[formatter stringFromNumber:medianPrice]]];
        } else if (error) {
            NSLog(@"Error Sales: %@", error);
        }
    }];
    
    [[StreetEasyManager sharedManager] getRentalsByArea:neighborhood withCompletionBlock:^(NSError *error, NSDictionary *data) {
        if (!error && data) {
            NSNumber *count = data[@"listing_count"];
            NSNumber *medianPrice = data[@"median_price"];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            [self.rentalsCountLabel setText:[NSString stringWithFormat:@"%@",count]];
            [self.rentalsPriceLabel setText:[NSString stringWithFormat:@"$%@",[formatter stringFromNumber:medianPrice]]];
        } else if (error) {
            NSLog(@"Error Rentals: %@", error);
        }
    }];
}

#pragma mark Neighborhood Polygon Rendering

- (void)getGeometryForNeighborhood:(NSString*)neighborhood {
    [[StreetEasyManager sharedManager] getGeometryByArea:neighborhood withCompletionBlock:^(NSError *error, NSArray *data) {
        if (!error && data) {
            CLLocationCoordinate2D coordinates[data.count];
            
            for (int i = 0; i < data.count;i++) {
                NSArray *coordinate = data[i];
                NSNumber *longitude = coordinate[0];
                NSNumber *latitude = coordinate[1];

                coordinates[i] = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
            }
            [self drawPolygonOnMapWithCoordinates:coordinates withCount:data.count];
        } else {
            
        }
    }];
}

- (void)drawPolygonOnMapWithCoordinates:(CLLocationCoordinate2D*)coordinates withCount:(NSInteger)count{
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coordinates count:count];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    [self.mapView addOverlay:polygon level:MKOverlayLevelAboveRoads];
}

- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MKPolygon.class]) {
        MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        
        UIColor *blueColor = kBlueColor;
        [polygonView setStrokeColor:blueColor];
        [polygonView setLineWidth:3.0];
        [polygonView setFillColor:[blueColor colorWithAlphaComponent:0.25]];
        
        return polygonView;
    }
    
    return nil;
}

@end
