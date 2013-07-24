//
//  AFStreetShoutAPIClient.m
//  street-shout-ios
//
//  Created by Bastien Beurier on 7/17/13.
//  Copyright (c) 2013 Street Shout. All rights reserved.
//

#import "AFStreetShoutAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "Shout.h"

static NSString * const kAFStreetShoutAPIBaseURLString = @"http://dev-street-shout.herokuapp.com/";

@implementation AFStreetShoutAPIClient

+ (AFStreetShoutAPIClient *)sharedClient
{
    static AFStreetShoutAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFStreetShoutAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFStreetShoutAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

+ (void)pullShoutsInZone:(NSArray *)cornersCoordinates AndExecute:(void(^)(NSArray *shouts))block
{
    NSDictionary *parameters = @{@"neLat": cornersCoordinates[0],
                                 @"neLng": cornersCoordinates[1],
                                 @"swLat": cornersCoordinates[2],
                                 @"swLng": cornersCoordinates[3]};
    
    //TODO: change endpoint
    [[AFStreetShoutAPIClient sharedClient] getPath:@"bound_box_shouts.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSArray *rawShouts = [JSON valueForKeyPath:@"result"];
        
        block([Shout rawShoutsToInstances:rawShouts]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR!!!");
        //TODO: implement
    }];
}

+ (void)createShoutWithLat:(double)lat Lng:(double)lng Username:(NSString *)userName Description:(NSString *)description Image:(NSString *) imageUrl
{
    //TODO: add device_id
    NSMutableDictionary *parameters;
    
    [parameters setObject:userName forKey:@"user_name"];
    [parameters setObject:description forKey:@"description"];
    [parameters setObject:[NSNumber numberWithDouble:lat] forKey:@"lat"];
    [parameters setObject:[NSNumber numberWithDouble:lng] forKey:@"lng"];
    
    if (imageUrl) {
        [parameters setObject:imageUrl forKey:@"image"];
    }
    
    [[AFStreetShoutAPIClient sharedClient] getPath:@"shouts.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Json response: %@", (NSString *) JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR!!!");
        //TODO: implement
    }];
}

@end
