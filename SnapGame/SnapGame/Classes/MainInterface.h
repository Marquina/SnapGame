//
//  MainInterface.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainInterface : UIViewController  {
	IBOutlet UILabel *queueInfo;
	IBOutlet UILabel *extraInfo;
}


- (IBAction) websiteBtn: sender;
- (IBAction) hollabackBtn: sender;
- (IBAction) infoBtn: sender;

- (IBAction) loginBtn: sender;
- (void) updateMessagesInQueue;

@end


