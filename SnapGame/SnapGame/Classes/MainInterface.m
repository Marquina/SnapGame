//
//  MainInterface.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MainInterface.h"
#import "iphone_rightridesAppDelegate.h"
#import "MessageQueue.h"
#import "Communcations.h"
#import "MessageQueue.h"

@implementation MainInterface

- (IBAction) websiteBtn: sender {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	[appDel website];
}

- (IBAction) hollabackBtn: sender {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	[appDel reportscreen];
}

- (IBAction) infoBtn: sender {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	[appDel info];
}


- (IBAction) loginBtn: sender {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	[appDel loginscreen];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[self updateMessagesInQueue];
}

- (void) updateMessagesInQueue {
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	
	int numMsgs = [appDel.comm.queue dbMsgCount];
	NSLog(@"Maininterface:viewdidload: numMsgs value : %d", numMsgs);
	NSString *queueMsg = [[NSString alloc] initWithFormat:@"There are %d messages in the queue", numMsgs];
	[queueInfo setText:queueMsg];
	[queueMsg release];
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
