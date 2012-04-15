//
//  MainInterfaceWebsite.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MainInterfaceWebsite.h"
#import "MainInterfaceWebsiteView.h"
#import "iphone_rightridesAppDelegate.h"

@implementation MainInterfaceWebsite

@synthesize webview;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self loadView];
    }
    return self;
}

- (void) loadwebsite {
	NSURL *url = [NSURL URLWithString:@"http://www.ihollaback.org/"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webview.webview loadRequest: request];
}


- (IBAction) menuBtn: sender {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	[appDel maininterface];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadwebsite];
}

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
