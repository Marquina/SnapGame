//
//  HollabackViewController.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HollabackViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	//Location Specific
	/*
	 CLLocationManager *locationManager;
	 NSMutableArray *locationMeasurements;
	 CLLocation *bestEffortAtLocation;
	 
	 NSMutableArray *images;
	 
	 UIImageView *image01;
	 UIImageView *image02;
	 UIImageView *image03;
	 
	 UIButton *picButton;
	 
	 UIImagePickerController *imagePicker;
	 */
}
/*
 @property (nonatomic, retain) CLLocationManager *locationManager;
 @property (nonatomic, retain) NSMutableArray *locationMeasurements;
 @property (nonatomic, retain) CLLocation *bestEffortAtLocation;
 
 @property (nonatomic, retain) IBOutlet UIImageView *image01;
 @property (nonatomic, retain) IBOutlet UIImageView *image02;
 @property (nonatomic, retain) IBOutlet UIImageView *image03;
 
 @property (nonatomic, retain) IBOutlet UIButton *picButton;
 
 - (IBAction) sendHollback: sender;
 - (IBAction) takeImage: sender;
 
 - (void) updateGUI;
 
 - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
 - (void) startUpdatingLocation;
 - (void)stopUpdatingLocation:(NSString *)state;
 */
@end
