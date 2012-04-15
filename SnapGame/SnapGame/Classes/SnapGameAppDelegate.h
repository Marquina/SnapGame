//
//  SnapGameAppDelegate.h
//  SnapGame
//
//  Created by Daniel Piselli on 6/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnapGameViewController;

@interface SnapGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SnapGameViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SnapGameViewController *viewController;

@end

