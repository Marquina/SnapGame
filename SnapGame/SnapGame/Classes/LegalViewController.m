//
//  LegalViewController.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/17/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LegalViewController.h"
#import "iphone_rightridesAppDelegate.h"

@implementation LegalViewController

//@synthesize agreeView;
//@synthesize menuView;

- (IBAction) disagreeBtn: sender {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	
	[appDel.prefs setObject: @"no" forKey:@"legalapproval"];
	[appDel.prefs synchronize];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hollaback" message:@"Thank you for downloading hollaback" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (IBAction) agreeBtn: sender {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	
	[appDel.prefs setObject: @"yes" forKey:@"legalapproval"];
	[appDel.prefs synchronize];
	[appDel switchBoard];
}

- (IBAction) menuBtn: sender {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	[appDel maininterface];
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
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
}

/*
 - (void) updateViewableButtons {
 iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
 
 NSString *legalapproval = [appDel.prefs objectForKey:@"legalapproval"];
 if( legalapproval == Nil ) {
 agreeView.hidden = YES;
 menuView.hidden = NO;
 } else {
 agreeView.hidden = NO;
 menuView.hidden = YES;
 }
 
 [self.agreeView setNeedsDisplay];
 [self.menuView setNeedsDisplay];
 [self.view setNeedsDisplay];
 }
 */

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
    [super dealloc];
}


@end
