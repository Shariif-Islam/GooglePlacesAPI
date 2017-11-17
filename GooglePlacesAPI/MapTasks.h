//
//  MapTasks.h
//  GooglePlacesAPI
//
//  Created by Shariif on 12/12/16.
//  Copyright © 2016 Shariif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapTasks : NSObject

@property (nonatomic) NSString* fetchedFormattedAddress;
@property (nonatomic) double fetchedAddressLongitude;
@property (nonatomic) double fetchedAddressLatitude;

- (void)geocodeAddress:(NSString *)address
            completion:(void (^)(NSString* status, bool success))completionBlock;

@end
