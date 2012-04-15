//
//  iphone_rightridesAppDelegate.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/7/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class MainInterface;
@class LegalViewController;
@class Communcations;
@class AuthenticationViewController;
@class ReportViewController;
@class HarassementTypes;
@class UserSignupViewController;
@class TakePhotoViewController;
@class ConfirmationViewController;
@class HollabackMsg;
@class MainInterfaceWebsite;
@class InfoViewController;

@interface iphone_rightridesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
	
	MainInterface *mainInterface;
	LegalViewController *legalInterfaceAgreeDisagree;
	LegalViewController *legalInterfaceMenu;
	AuthenticationViewController *loginInterface;
	ReportViewController *reportviewcontroller;
	HarassementTypes *harassementtype;
	UserSignupViewController *signupInterface;
	TakePhotoViewController *takePicViewController;
	ConfirmationViewController *confirmViewController;
	MainInterfaceWebsite *websiteViewController;
	InfoViewController *infoviewcontroller;
	
	Communcations * comm;
	CLLocationManager *locationManager;
	
	HollabackMsg *hollabackMsg;
	
	NSUserDefaults *prefs;
	
	BOOL badLoginMsgDisplayed;
}

@property (nonatomic, retain) Communcations * comm;

@property (nonatomic, retain) IBOutlet NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet MainInterface *mainInterface;
@property (nonatomic, retain) IBOutlet LegalViewController *legalInterfaceAgreeDisagree;
@property (nonatomic, retain) IBOutlet LegalViewController *legalInterfaceMenu;
@property (nonatomic, retain) IBOutlet AuthenticationViewController *loginInterface;
@property (nonatomic, retain) IBOutlet ReportViewController *reportviewcontroller;
@property (nonatomic, retain) IBOutlet HarassementTypes *harassementtype;
@property (nonatomic, retain) IBOutlet UserSignupViewController *signupInterface;
@property (retain) IBOutlet TakePhotoViewController *takePicViewController;
@property (nonatomic, retain) IBOutlet ConfirmationViewController *confirmViewController;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) HollabackMsg *hollabackMsg;
@property (nonatomic, retain) MainInterfaceWebsite *websiteViewController;
@property (nonatomic, retain) InfoViewController *infoviewcontroller;

- (void) preloadwebcontroller;
- (void) backgroundLoad;
- (void) switchBoard;

- (BOOL) verifylogin: (NSString *) un password: (NSString *) pwd;
- (void) legalscreen;
- (void) loginscreen;
- (void) maininterface;
- (void) reportscreen;
- (void) harassementtypes;
- (void) signupinterface;
- (void) takepicture;
- (void) confirmation;
- (void) website;
- (void) info;
- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

- (void) findLocation;

- (HollabackMsg *) newHollabackMsg;

- (void) pushController: (UIViewController *) vc;

- (void) authenticationFailed;


@end

