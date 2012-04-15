//
//  HarassementTypes.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 5/1/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "HarassementTypes.h"
#import "iphone_rightridesAppDelegate.h"
#import "HollabackMsg.h"
#import "Communcations.h"

@implementation HarassementTypes

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (IBAction) harassementTypeBtn: sender {
	iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
	UIButton *btn = (UIButton *) sender;
	appdelgate.hollabackMsg.harrssementType = btn.titleLabel.text;
	[appdelgate.comm queueHollaback: appdelgate.hollabackMsg];
	[appdelgate confirmation];
}

- (IBAction) shootagainBtn: sender {
	iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
	[appdelgate takepicture];
}

- (IBAction) menuBtn: sender {
	iphone_rightridesAppDelegate *appdelgate = (iphone_rightridesAppDelegate *)[ [UIApplication sharedApplication]  delegate];
	[appdelgate maininterface];
}

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
