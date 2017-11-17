//
//  MapTasks.m
//  GooglePlacesAPI
//
//  Created by Shariif on 12/12/16.
//  Copyright © 2016 Shariif. All rights reserved.
//

#import "MapTasks.h"

@import GoogleMaps;

NSString* baseURLGeocode = @"https://maps.googleapis.com/maps/api/geocode/json?";
NSString* baseURLDirections = @"https://maps.googleapis.com/maps/api/directions/json?";
NSString* originAddress;
NSString* destinationAddress;

NSDictionary* dic_lookupAddressResult;
NSDictionary* dic_selectedRoute;
NSDictionary* dic_overviewPolyline;

CLLocationCoordinate2D* originCoordinate;
CLLocationCoordinate2D* destinationCoordinate;

@implementation MapTasks{

    MapTasks* mapTask;
}


/**
 * The first parameter is the address we want to spot to the map. 
 * The second parameter is a completion handler that will be called once we have received and processed the response data.
 * The app will display results to the map only after this completion handler has been called by this method.
 */
- (void)geocodeAddress:(NSString *)address
                       completion:(void (^)(NSString* status, bool success))completionBlock
{
    if (address != nil) {
        
        /**
         * Compose the URL string with the address given
         */
        NSString* geocodeURLString = [NSString stringWithFormat:@"%@address=%@",baseURLGeocode,address];
        geocodeURLString = [geocodeURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL* geocodeURL = [NSURL URLWithString:geocodeURLString];
        
        /**
         * Make a request to the geocoding API and store the returned results to a NSData object.
         * All action will be done asynchronously.
         * So, the app be responsive during the data fetching period,
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSData* geocodingresultsData = [NSData dataWithContentsOfURL:geocodeURL];
            NSError* error;
            NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:geocodingresultsData
                                                                 options:kNilOptions
                                                                   error:&error];
            if (error) {
                
                NSLog(@"error %@",error);
                completionBlock(@"",false);
                
            } else {
            
                NSString* status = [dictionary valueForKey:@"status"];
                
                if ([status isEqualToString:@"OK"]){
                    
                    NSArray* result = [dictionary valueForKey:@"results"];
                    dic_lookupAddressResult = [result objectAtIndex:0];
                    _fetchedFormattedAddress = [dic_lookupAddressResult valueForKey:@"formatted_address"];
                    
                    NSDictionary* geometry = [dic_lookupAddressResult valueForKey:@"geometry"];
                    _fetchedAddressLatitude = [[[geometry valueForKey:@"location"] valueForKey:@"lat"] doubleValue];
                    _fetchedAddressLongitude = [[[geometry valueForKey:@"location"] valueForKey:@"lng"] doubleValue];
                    
                    completionBlock(status,true);
                    
                } else {
                
                    completionBlock(status,false);
                    
                }
                
            }
        });
    } else {
    
        completionBlock(@"No valid address",false);
    }
  
}

/**
 * Besides the origin and destination locations (expressed as addresses),
 * this method also accepts and array with the waypoints (the intermediate points in a route),
 * and the travel mode of the journey that will be drawn on the map.
 * With the travel mode, we’ll be able to define whether we want directions for driving, walking, or bicycling.
 */
- (void)getDirections:(NSString *)origin
         destination :(NSString*) destination
           wayPoints :(NSArray*) wayPoints
          travelMode :(NSObject*) travelMode

            completion:(void (^)(NSString* status, bool success))completionBlock
{
    if (origin != nil && destination != nil) {
        
        /**
         * Compose the URL string with the address given
         */
        NSString* directionURLString = [NSString stringWithFormat:@"%@origin=%@&destination=%@",baseURLDirections, origin, destination];
        directionURLString = [directionURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL* directionsURL = [NSURL URLWithString:directionURLString];
        
    } else {
    
        completionBlock(@"Origin or destination is nil",false);
    }
}

@end
