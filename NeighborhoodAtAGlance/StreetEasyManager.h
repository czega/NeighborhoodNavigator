//
//  StreetEasyManager.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/26/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>

@interface StreetEasyManager : NSObject

+ (id)sharedManager;

- (void)getAreaByLocation:(CLLocationCoordinate2D)location withCompletionBlock:(void(^)(NSError *error, NSDictionary* data))completionBlock;
- (void)getRentalsByArea:(NSString*)area withCompletionBlock:(void(^)(NSError *error, NSDictionary* data))completionBlock;
- (void)getSalesByArea:(NSString*)area withCompletionBlock:(void(^)(NSError *error, NSDictionary* data))completionBlock;
- (void)getGeometryByArea:(NSString*)area withCompletionBlock:(void(^)(NSError *error, NSArray* data))completionBlock;

@end
