//
//  ViewController.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/26/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *neighborhoodInformationView;
@property (weak, nonatomic) IBOutlet UILabel *neighborhoodLabel;

@property (weak, nonatomic) IBOutlet UILabel *salesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *rentalsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentalsPriceLabel;

- (IBAction)filterButtonSelected:(id)sender;

- (void)filterOptionsUpdated;

@end

