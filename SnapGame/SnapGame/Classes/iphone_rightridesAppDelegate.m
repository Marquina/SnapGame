//
//  iphone_rightridesAppDelegate.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/7/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "iphone_rightridesAppDelegate.h"
#import "RootViewController.h"
#import "UserSignupViewController.h"
#import "MainInterface.h"
#import "LegalViewController.h"
#import "Communcations.h"
#import "AuthenticationViewController.h"
#import "ReportViewController.h"
#import "HarassementTypes.h"
#import "TakePhotoViewController.h"
#import "ConfirmationViewController.h"
#import "HollabackMsg.h"
#import "MainInterfaceWebsite.h"
#import "InfoViewController.h"

//TODO: animate transitions

@implementation iphone_rightridesAppDelegate

@synthesize prefs;

@synthesize window;
@synthesize navigationController;
@synthesize comm;

@synthesize mainInterface;
@synthesize legalInterfaceAgreeDisagree;
@synthesize legalInterfaceMenu;
@synthesize loginInterface;
@synthesize reportviewcontroller;
@synthesize harassementtype;
@synthesize signupInterface;
@synthesize takePicViewController;
@synthesize confirmViewController;
@synthesize locationManager;
@synthesize websiteViewController;
@synthesize hollabackMsg;
@synthesize infoviewcontroller;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.prefs = [NSUserDefaults standardUserDefaults];
	
	badLoginMsgDisplayed = NO;
	
	[NSThread detachNewThreadSelector: @selector(backgroundLoad) toTarget:self withObject: nil];
	
    // Override point for customization after app launch    
	[window addSubview:[navigationController view]];
	[self copyDatabaseIfNeeded];
	
	//Creat communication help class
	self.comm = [[Communcations alloc] init];
	[self findLocation];
	[self switchBoard];
	
	// Activate window
    [window makeKeyAndVisible];
	return YES;
}

- (void) preloadwebcontroller {
	self.websiteViewController = [[MainInterfaceWebsite alloc] initWithNibName: @"WebsiteViewController" bundle:nil];
	[self.websiteViewController loadwebsite];
}

- (void) backgroundLoad {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//Peeload the bigger xib files here
	
	//Make sure to give the main thread some time
	[NSThread sleepForTimeInterval: 0.5];
	self.takePicViewController = [[TakePhotoViewController alloc] init];
	
	[NSThread sleepForTimeInterval: 0.05];
	self.mainInterface = [[MainInterface alloc] initWithNibName: @"MainInterface" bundle:nil];
	
	[NSThread sleepForTimeInterval: 0.05];
	[self performSelectorOnMainThread:@selector(preloadwebcontroller) withObject:Nil waitUntilDone:NO];
	
	[pool release];
}

- (void) switchBoard {
	
	// First look up varibles that could have already been set in the person's settings
	NSString *legalapproval = [prefs objectForKey:@"legalapproval"];
	NSString *username = [prefs objectForKey:@"username"];
	NSString *pwd = [prefs objectForKey:@"password"];
	NSString *authstatus = [prefs objectForKey:@"authstatus"];
	
	//First check to see if the user has agreed to the legal disclosure
	if( legalapproval == nil ) {
		[self legalscreen];
	} else {
		if( [legalapproval isEqualToString: @"no"] ) {
			[self legalscreen];
		} else {
			//check to see if the person has a valid, acceptable id.
			if( (username == nil || pwd == nil) || authstatus == nil ) {
				[self loginscreen];
			} else {
				[self reportscreen];
			}
		}
	}	
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// TODO: Save data if appropriate
}

#pragma mark -
#pragma mark util
- (BOOL) verifylogin: (NSString *) un password: (NSString *) pwd {
	[comm authenticateUser:un password:pwd];
	return YES;
}

- (void) findLocation {
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self.comm;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    //[self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:[[setupInfo objectForKey:kSetupInfoKeyTimeout] doubleValue]];
	
}

#pragma mark -
#pragma mark Switching Views

- (void) legalscreen {
	NSString *legalapproval = [prefs objectForKey:@"legalapproval"];
	
	if( legalapproval == Nil ) {
		if( legalInterfaceAgreeDisagree == nil) {
			legalInterfaceAgreeDisagree = [[LegalViewController alloc] initWithNibName: @"LegalScreen" bundle:nil];
		}
		
		[self pushController:legalInterfaceAgreeDisagree];
		//[legalInterface updateViewableButtons];
	} else {
		if( legalInterfaceMenu == nil) {
			legalInterfaceMenu = [[LegalViewController alloc] initWithNibName: @"LegalScreenMenu" bundle:nil];
		}
		
		[self pushController:legalInterfaceMenu];
		//[legalInterface updateViewableButtons];
	}
	
	
	
}

- (void) loginscreen {
	if( loginInterface == nil) {
		loginInterface = [[AuthenticationViewController alloc] initWithNibName: @"LoginInterface" bundle:nil];
	}
	
	[self pushController:loginInterface];
}

- (void) maininterface {
	if( mainInterface == nil) {
		//hot spin until value is set
		while( mainInterface == nil ) { [NSThread sleepForTimeInterval: 0.01]; }
	}
	
	[self pushController:mainInterface];
}

- (void) reportscreen {
	if( reportviewcontroller == nil) {
		reportviewcontroller = [[ReportViewController alloc] initWithNibName: @"Report" bundle:nil];
	}
	
	[self pushController:reportviewcontroller];	
}

- (void) harassementtypes {
	if( harassementtype == nil) {
		harassementtype = [[HarassementTypes alloc] initWithNibName: @"HarassmentTypes" bundle:nil];
	}
	
	[self pushController:harassementtype];	
}


- (void) signupinterface {
	
	if( signupInterface == nil) {
		signupInterface = [[UserSignupViewController alloc] initWithNibName: @"UserSignupViewController" bundle:nil];
	}
	
	[self pushController:signupInterface];
}

- (void) takepicture {
	if( takePicViewController == nil) {
		//hot spin until value is set
		while( takePicViewController == nil ) { [NSThread sleepForTimeInterval: 0.01]; }
	}
	
	[self.navigationController presentModalViewController: takePicViewController animated: YES];
}

- (void) confirmation {
	if( confirmViewController == nil) {
		confirmViewController = [[ConfirmationViewController alloc] initWithNibName: @"ConfirmationOfHollaback" bundle:nil];
	}
	
	[self pushController:confirmViewController];
}

- (void) website {
	if( websiteViewController == nil) {
		while( websiteViewController == nil ) { [NSThread sleepForTimeInterval: 0.01]; }
	}
	
	[self pushController:websiteViewController];	
}

- (void) info {
	if( infoviewcontroller == nil) {
		infoviewcontroller = [[InfoViewController alloc] initWithNibName: @"InfoViewController" bundle:nil];
	}
	
	[self pushController:infoviewcontroller];	
}


- (void) pushController: (UIViewController *) vc {
	if( [navigationController.viewControllers containsObject: vc] ) {
		[navigationController popToViewController: vc animated:YES];
	} else {
		[navigationController pushViewController: vc animated: YES];	
	}
}


- (HollabackMsg *) newHollabackMsg {
	[self.hollabackMsg release];
	self.hollabackMsg = [[HollabackMsg alloc] init];
	return self.hollabackMsg;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	badLoginMsgDisplayed = NO; 
	if (buttonIndex == 0 ){
		[self maininterface];
	} else {
		[self loginscreen];
	}
}

- (void) authenticationFailed {
	if( badLoginMsgDisplayed == NO ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication" 
														message:@"We were unable to authenticate your hollaback, please login again with your correct username and password"
													   delegate:self cancelButtonTitle:@"menu" otherButtonTitles:@"login", nil];
		[alert show];
		[alert release];
	}
	badLoginMsgDisplayed = YES;
}


#pragma mark -
#pragma mark local database management

- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	NSLog(@"%@", dbPath);
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hollaback.sqlite3"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		else {
			NSLog(@"database copied to users filesystem succesfully");
		}
		
	}
	else {
		NSLog(@"database exists in the users filesystem");
	}
	
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"hollaback.sqlite3"];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[prefs release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

