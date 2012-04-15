//
//  MainInterfaceWebsite.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainInterfaceWebsiteView;

@interface MainInterfaceWebsite : UIViewController {
	MainInterfaceWebsiteView *webview;
}

@property (nonatomic, retain) IBOutlet MainInterfaceWebsiteView *webview;

- (IBAction) menuBtn: sender;

- (void) loadwebsite;

@end
