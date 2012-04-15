//
//  UserSignupViewController.m
//  iphone_rightrides
//
//  Created by Abhinav sharma on 4/30/10.
//  Copyright 2010 Orangmico LLC. All rights reserved.
//

#import "UserSignupViewController.h"
#import "iphone_rightridesAppDelegate.h"
#import "Communcations.h"



@implementation UserSignupViewController

@synthesize username;
@synthesize password;
@synthesize email;
@synthesize email_confirm;
@synthesize backBtn;

-(IBAction)signupButton:(id)sender {
	
	iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
	Communcations *comm = [appdelgate comm];
	
	comm.delegate = self;
	
	
	if( [email.text caseInsensitiveCompare:email_confirm.text] == NSOrderedSame ) {
		if (username.text.length == 0 || password.text.length == 0 || email.text.length == 0) {
			username.enabled = NO;
			password.enabled = NO;
			email.enabled = NO;
			email_confirm.enabled = NO;
			statuslabel.text = @"Please fill all fields";
			username.enabled = YES;
			password.enabled = YES;
			email.enabled = YES;
			email_confirm.enabled = YES;
		} else {
			
			
			
			statuslabel.text = @"Sending sign up request to server";
			[activityView startAnimating];
			
			username.enabled = NO;
			password.enabled = NO;
			email.enabled = NO;
			email_confirm.enabled = NO;
			
			[comm signupUser: username.text password: password.text email: email.text];
		}
	} else {
		username.enabled = NO;
		password.enabled = NO;
		email.enabled = NO;
		email_confirm.enabled = NO;
		statuslabel.text = @"Emails did not match";
		username.enabled = YES;
		password.enabled = YES;
		email.enabled = YES;
		email_confirm.enabled = YES;
	}
}

-(IBAction)backButton:(id)sender {
	iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
	[appdelgate loginscreen];
}


- (void) communcationCallback: (Communcations *)comm status: (NSString *) stat response: (NSString *) msg {
	if( [stat isEqualToString: @"okay"] ) {
		iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
		
		//store username and pass, since it seemed to be good
		[appdelgate.prefs setObject: @"username" forKey:username.text];
		[appdelgate.prefs setObject: @"password" forKey:password.text];
		[appdelgate.prefs setObject: @"authstatus" forKey: @"okay"];
		
		[appdelgate.prefs synchronize];
		
		//
		NSLog( @"%@", msg );
		statuslabel.text = @"Sign Up Succesful!!";
		
		[appdelgate reportscreen];
	} else if ( [stat isEqualToString: @"error"] ) {
		if ([msg isEqualToString: @"Username Already Exist"]) {
			statuslabel.text = msg;
		} else if ([msg isEqualToString:@"Connection failed!"]) {
			statuslabel.text = @"Unable to Connect";
		} else {
			statuslabel.text = msg;	
		}
	}
	
	username.enabled = YES;
	password.enabled = YES;
	email.enabled = YES;
	email_confirm.enabled = YES;
	
	[activityView stopAnimating];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
    return YES;
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

-(void)keyboardWillShow:(NSNotification *)notif {
	if (self.view.window!=nil) {
		[UIView beginAnimations: @"hideheader_usersignup" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.3f];
		
		headerView.alpha = 0.0;
		mainView.frame = CGRectMake(mainView.frame.origin.x, -90.0, mainView.frame.size.width, mainView.frame.size.height) ;
		backBtn.alpha = 0.0;
		
		[UIView commitAnimations];
	}
}

-(void)keyboardWillHide:(NSNotification *)notif {
	if (self.view.window!=nil) {
		[UIView beginAnimations: @"showheader_usersignup" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.3f];
		
		headerView.alpha = 1.0;
		mainView.frame = CGRectMake(mainView.frame.origin.x, 0.0, mainView.frame.size.width, mainView.frame.size.height) ;
		backBtn.alpha = 1.0;
		
		[UIView commitAnimations];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	username.delegate = self;
	password.delegate = self;
	
	email.delegate = self;
	email_confirm.delegate = self;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void)dealloc {
    [super dealloc];
}


@end
