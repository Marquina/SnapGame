//
//  AuthenticationViewController.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "iphone_rightridesAppDelegate.h"
#import "Communcations.h"

@implementation AuthenticationViewController

@synthesize headerView;
@synthesize username;
@synthesize password;
@synthesize activityView;
@synthesize textView;
@synthesize mainView;

- (IBAction) authenticateBtn: sender {
	iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
	Communcations *comm = [appdelgate comm];
	
	comm.delegate = self;
	textView.text = @"Sending authentication request to server";
	
	[activityView startAnimating];
	
	username.enabled = NO;
	password.enabled = NO;
	
	[comm authenticateUser: username.text password: password.text];
	//[appdelgate reportscreen];
}

- (IBAction)signupBtn: (id)sender {
	
	iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
	
	[appdelgate signupinterface];
	
	//username.enabled = NO;
	//password.enabled = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
    return YES;
}

- (void) communcationCallback: (Communcations *)comm status: (NSString *) stat response: (NSString *) msg {
	if( [stat isEqualToString: @"okay"] ) {
		iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
		
		//store username and pass, since it seemed to be good
		NSString *okay = [[NSString alloc] initWithString: @"okay"];
		[appdelgate.prefs setObject: username.text  forKey: @"username"];
		[appdelgate.prefs setObject: password.text  forKey: @"password"];
		[appdelgate.prefs setObject: @"okay" forKey:@"authstatus"];
		[okay release];
		
		[appdelgate.prefs synchronize];
		
		textView.text = @"Authenticated";
		
		[appdelgate reportscreen];
	} else if ( [stat isEqualToString: @"error"] ) {
		textView.text = @"Authentication failed";
		if ([msg isEqualToString:@"Connection failed!"]) {
			textView.text = @"Unable to Connect";
		}
	}
	
	username.enabled = YES;
	password.enabled = YES;
	
	[activityView stopAnimating];
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];	
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
		iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
		NSLog(@"Authenticationviewcontroller: initwithnib");
		
		[appdelgate.prefs removeObjectForKey: @"username"];
		[appdelgate.prefs removeObjectForKey: @"password"];
		[appdelgate.prefs removeObjectForKey: @"authstatus"];
		
		[appdelgate.prefs synchronize];
		
	}
    return self;
}


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"authentication viewdidload");
	username.delegate = self;
	password.delegate = self;
	username.enabled = YES;
	password.enabled = YES;
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

/*
 -(void)keyboardWillShow:(NSNotification *)notif {
 if (self.view.window!=nil) {
 [UIView beginAnimations: @"hideheader" context:nil];
 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
 [UIView setAnimationDuration:0.3f];
 
 headerView.alpha = 0.0;
 mainView.frame = CGRectMake(mainView.frame.origin.x, -90.0, mainView.frame.size.width, mainView.frame.size.height) ;
 
 [UIView commitAnimations];
 }
 }
 
 -(void)keyboardWillHide:(NSNotification *)notif {
 if (self.view.window!=nil) {
 [UIView beginAnimations: @"showheader" context:nil];
 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
 [UIView setAnimationDuration:0.3f];
 
 headerView.alpha = 1.0;
 mainView.frame = CGRectMake(mainView.frame.origin.x, 0.0, mainView.frame.size.width, mainView.frame.size.height) ;
 
 [UIView commitAnimations];
 }
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}


@end
