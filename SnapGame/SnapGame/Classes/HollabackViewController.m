//
//  HollabackViewController.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "HollabackViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Communcations.h"
#import "iphone_rightridesAppDelegate.h"

@implementation HollabackViewController
/*
 @synthesize locationManager;
 @synthesize locationMeasurements;
 @synthesize bestEffortAtLocation;
 
 @synthesize image01;
 @synthesize image02;
 @synthesize image03;
 
 @synthesize picButton;
 *
 - (void) updateGUI {
 //	if( [images count] >= 1 ) {
 //		picButton.enabled = NO;
 //	}
 }
 
 /*
 - (IBAction) sendHollback: sender {
 
 iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
 Communcations *comm = [appdelgate comm];
 
 if ( comm.userAuthenticated ) {
 [comm sendHollback: nil];
 }
 
 }
 
 - (IBAction) takeImage: sender {
 iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
 
 // Show image picker
 [appdelgate.navigationController presentModalViewController: imagePicker animated: YES];
 }
 
 - (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
 
 // Access the uncropped image from info dictionary
 UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
 [images addObject: image];
 
 switch ( [images count] ) {
 case 1:
 image01.image = image;
 break;
 case 2:
 image02.image = image;
 break;
 case 3:
 image03.image = image;
 break;
 default:
 break;
 }
 
 [self updateGUI];
 [appdelgate.navigationController dismissModalViewControllerAnimated:YES];
 //[picker release];
 }
 */
/*
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
 UIAlertView *alert;
 
 // Unable to save the image  
 if (error)
 alert = [[UIAlertView alloc] initWithTitle:@"Error" 
 message:@"Unable to save image to Photo Album." 
 delegate:self cancelButtonTitle:@"Ok" 
 otherButtonTitles:nil];
 else // All is well
 alert = [[UIAlertView alloc] initWithTitle:@"Success" 
 message:@"Image saved to Photo Album." 
 delegate:self cancelButtonTitle:@"Ok" 
 otherButtonTitles:nil];
 [alert show];
 [alert release];
 }
 */

#pragma mark -
#pragma mark UIViewController
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	NSLog(@"loadView");
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	/*
	 if( images == NULL ) {
	 images = [[NSMutableArray alloc] initWithCapacity: 6];
	 
	 // Create image picker controller
	 imagePicker = [[UIImagePickerController alloc] init];
	 
	 // Set source to the camera, if camera not available set photolibrary as source, else display alert
	 
	 
	 
	 if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
	 
	 
	 imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	 
	 imagePicker.delegate = self;
	 //			imagePicker.allowsImageEditing = NO;
	 }
	 else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
	 
	 
	 imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	 
	 imagePicker.delegate = self;
	 //			imagePicker.allowsImageEditing = NO;
	 }
	 else {
	 imagePicker = nil;
	 
	 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera Found"
	 message:@"You need an iPhone with a camera to use this application."
	 delegate:self
	 cancelButtonTitle:@"Cancel"
	 otherButtonTitles:@"Ok", nil];
	 
	 [alertView show];
	 [alertView release];
	 }
	 
	 
	 
	 //imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
	 //imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	 // Delegate is self
	 //imagePicker.delegate = self;
	 
	 locationManager = [[[CLLocationManager alloc] init] autorelease];
	 locationManager.delegate = self;
	 [self startUpdatingLocation];
	 
	 }
	 */
}


#pragma mark -
#pragma mark Location Finding

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
/*
 - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
 // store all of the measurements, just so we can see what kind of data we might receive
 [locationMeasurements addObject:newLocation];
 // test the age of the location measurement to determine if the measurement is cached
 // in most cases you will not want to rely on cached measurements
 NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
 if (locationAge > 5.0) return;
 // test that the horizontal accuracy does not indicate an invalid measurement
 if (newLocation.horizontalAccuracy < 0) return;
 // test the measurement to see if it is more accurate than the previous measurement
 if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
 // store the location as the "best effort"
 self.bestEffortAtLocation = newLocation;
 // test the measurement to see if it meets the desired accuracy
 //
 // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
 // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
 // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
 //
 if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
 // we have a measurement that meets our requirements, so we can stop updating the location
 // 
 // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
 //
 [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
 // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
 }
 }
 // update the display with the new location data
 //[self.tableView reloadData];    
 }
 
 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
 // The location "unknown" error simply means the manager is currently unable to get the location.
 // We can ignore this error for the scenario of getting a single location fix, because we already have a 
 // timeout that will stop the location manager to save power.
 if ([error code] != kCLErrorLocationUnknown) {
 [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
 }
 }
 
 - (void) startUpdatingLocation {
 // This is the most important property to set for the manager. It ultimately determines how the manager will
 // attempt to acquire location and thus, the amount of power that will be consumed.
 locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
 // Once configured, the location manager must be "started".
 [locationManager startUpdatingLocation];
 //[self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:30];	
 }
 
 - (void)stopUpdatingLocation:(NSString *)state {
 //    self.stateString = state;
 //    [self.tableView reloadData];
 [locationManager stopUpdatingLocation];
 locationManager.delegate = nil;
 
 //  UIBarButtonItem *resetItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"Reset") style:UIBarButtonItemStyleBordered target:self action:@selector(reset)] autorelease];
 //   [self.navigationItem setLeftBarButtonItem:resetItem animated:YES];;
 }
 */
#pragma mark -
#pragma mark 

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[locationManager release];
    [super dealloc];
}


@end
