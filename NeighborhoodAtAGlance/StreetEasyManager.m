//
//  StreetEasyManager.m
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/26/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "StreetEasyManager.h"

#define kBaseURL @"http://streeteasy.com/nyc/api"

#define kFindAreaEndpoint @"/areas/for_location"
#define kFindRentalsEndpoint @"/rentals/data"
#define kFindSalesEndpoint @"/sales/data"
#define kFindGeoJSONEndpoint @"/areas/geojson"

#define kAPIKey @"c41a671977bc786c7128db984d62bd5babc721a2"

@interface StreetEasyManager()

@property AFHTTPRequestOperationManager* requestManager;
@end

@implementation StreetEasyManager
+ (id)sharedManager {
    static StreetEasyManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)getAreaByLocation:(CLLocationCoordinate2D)location withCompletionBlock:(void (^)(NSError *, NSDictionary *))completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@?lon=%f&lat=%f&key=%@&format=json",kBaseURL,kFindAreaEndpoint,location.longitude,location.latitude,kAPIKey];
    [self sendGetRequestWithUrl:url withCompletionBlock:completionBlock];
}

- (void)getRentalsByArea:(NSString *)area withCompletionBlock:(void (^)(NSError *, NSDictionary *))completionBlock {
    NSString *filterString = [[FilterManager sharedManager] getRentalsFilterString];
    NSString *url = [NSString stringWithFormat:@"%@%@?criteria=area:%@%@&key=%@&format=json",kBaseURL,kFindRentalsEndpoint,area,filterString,kAPIKey];
    NSLog(@"Url: %@",url);
    [self sendGetRequestWithUrl:url withCompletionBlock:completionBlock];
}

- (void)getSalesByArea:(NSString *)area withCompletionBlock:(void (^)(NSError *, NSDictionary *))completionBlock {
    NSString *filterString = [[FilterManager sharedManager] getSalesFilterString];
    NSString *url = [NSString stringWithFormat:@"%@%@?criteria=area:%@%@&key=%@&format=json",kBaseURL,kFindSalesEndpoint,area,filterString,kAPIKey];
    [self sendGetRequestWithUrl:url withCompletionBlock:completionBlock];
}

- (void)getGeometryByArea:(NSString*)area withCompletionBlock:(void(^)(NSError *error, NSArray* data))completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@?areas=%@&key=%@&format=json",kBaseURL,kFindGeoJSONEndpoint,area,kAPIKey];
    [self sendGetRequestWithUrl:url withCompletionBlock:^(NSError *error, NSDictionary *dict) {
        if (!error && dict) {
            NSArray *features = dict[@"features"];
            NSArray *coordinates = features[0][@"geometry"][@"coordinates"];
            completionBlock(nil,coordinates[0]);
        } else {
            completionBlock(error,nil);
        }
    }];

}

- (void)sendGetRequestWithUrl:(NSString*)url withCompletionBlock:(void (^)(NSError *, NSDictionary *))completionBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionBlock) {
            completionBlock(nil,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(error,nil);
        }
    }];
}

@end
