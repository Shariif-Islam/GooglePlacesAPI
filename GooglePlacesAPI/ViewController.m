//
//  ViewController.m
//  GooglePlacesAPI
//
//  Created by Shariif on 12/12/16.
//  Copyright © 2016 Shariif. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MapTasks.h"


@interface ViewController ()

@end

@implementation ViewController {

    CLLocationManager *locationManager;
    BOOL didFindMyLocaion;
    MapTasks* mapsTask;
    GMSMarker* locationMarker;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    mapsTask = [[MapTasks alloc] init];
    
    // Request for user permission
    [locationManager requestWhenInUseAuthorization];
    
    // Default Location Dhaka, Bangladesh
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:23.810332 longitude:90.4125181 zoom:8.0];
    _v_map.camera = camera;
    
    /**
     * Changes in the myLocation property.
     * Know when the user’s location gets updated.
     */
    [_v_map addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (!didFindMyLocaion) {
        
        CLLocation *myLocation = change[NSKeyValueChangeNewKey];
        _v_map.camera = [GMSCameraPosition cameraWithTarget:myLocation.coordinate zoom:10.0];
        _v_map.settings.myLocationButton = true;
        
        didFindMyLocaion = true;
    }
    
}

#pragma mark - CLLocation Manager Delegate
/**
 * Check user permission for allow to access location
 */
-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _v_map.myLocationEnabled = true;
    }
}



#pragma IBOutlet Actions

- (IBAction)findAddress:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Address Finder" message:@"Type your address you wnat to find" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Address";
    }];
    
    UIAlertAction* findAction = [UIAlertAction actionWithTitle:@"Find" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        NSString* address = [[alert.textFields objectAtIndex:0] text];
        
        // Take input from the user and process the request.
        [mapsTask geocodeAddress:address completion:^(NSString *status, bool success) {
            
            if (!success) {
                
                NSLog(@"Status:%@",status);
                if ([status isEqualToString:@"ZERO_RESULTS"]) {
                    [self showAlertWithMessage:@"The location could not be found."];
                }
                
            } else {
            
                // Get the location cordinate
                CLLocationCoordinate2D locationCordinate = CLLocationCoordinate2DMake(mapsTask.fetchedAddressLatitude, mapsTask.fetchedAddressLongitude);
                // Display on map
                _v_map.camera = [GMSCameraPosition cameraWithTarget:locationCordinate zoom:14.0];
                // Setup location marker
                [self setupLocationMarker:locationCordinate];
                
            }
            
        }];
    }];
    
    UIAlertAction* closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:findAction];
    [alert addAction:closeAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (IBAction)createRoute:(id)sender {
}

- (IBAction)changeTravelMode:(id)sender {
}

- (IBAction)changeMapType:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Map Type" message:@"Select map type" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *normalAction = [UIAlertAction actionWithTitle:@"Normal" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _v_map.mapType = kGMSTypeNormal;
        
    }];
    
    UIAlertAction *terrainAction = [UIAlertAction actionWithTitle:@"Terrain" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _v_map.mapType = kGMSTypeTerrain;
        
    }];
    
    UIAlertAction *hybridAction = [UIAlertAction actionWithTitle:@"Hybrid" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _v_map.mapType = kGMSTypeHybrid;
        
    }];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil];
    
    //ToDo: add more map type
    
    [actionSheet addAction:normalAction];
    [actionSheet addAction:terrainAction];
    [actionSheet addAction:hybridAction];
    [actionSheet addAction:closeAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma Custom methods

-(void) showAlertWithMessage : (NSString*) message {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Google Places API Demo" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:closeAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) setupLocationMarker : (CLLocationCoordinate2D) cordinate{
    
    locationMarker = [GMSMarker markerWithPosition:cordinate];
    locationMarker.map = _v_map;
    locationMarker.title = mapsTask.fetchedFormattedAddress;
    locationMarker.appearAnimation = kGMSMarkerAnimationPop;
    locationMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    locationMarker.opacity = 0.75;
    locationMarker.flat = true;
 
}

@end
