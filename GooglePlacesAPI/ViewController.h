//
//  ViewController.h
//  GooglePlacesAPI
//
//  Created by Shariif on 12/12/16.
//  Copyright © 2016 Shariif. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btn_findAddress;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;
@property (weak, nonatomic) IBOutlet GMSMapView *v_map;


- (IBAction)findAddress:(id)sender;
- (IBAction)createRoute:(id)sender;
- (IBAction)changeTravelMode:(id)sender;
- (IBAction)changeMapType:(id)sender;

@end

