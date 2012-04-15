//
//  LegalViewController.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/17/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LegalViewController : UIViewController {
	//IBOutlet UIView *agreeView;
	//IBOutlet UIView *menuView;
}

//@property (nonatomic, retain) IBOutlet UIView *agreeView;
//@property (nonatomic, retain) IBOutlet UIView *menuView;

- (IBAction) disagreeBtn: sender;
- (IBAction) agreeBtn: sender;

- (IBAction) menuBtn: sender;

//- (void) updateViewableButtons;

@end
