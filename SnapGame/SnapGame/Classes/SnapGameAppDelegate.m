//
//  SnapGameAppDelegate.m
//  SnapGame
//
//  Created by Daniel Piselli on 6/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SnapGameAppDelegate.h"
#import "SnapGameViewController.h"

@implementation SnapGameAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
