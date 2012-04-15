//
//  AuthenticationViewController.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communcations.h"

@interface AuthenticationViewController : UIViewController <CommuncationsCallbacks, UITextFieldDelegate> {
	UITextField *username;
	UITextField *password;
	
	UIActivityIndicatorView *activityView;
	UILabel *textView;
	
	UIView *headerView;
	UIView *mainView;
}

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UIView *mainView;

@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) IBOutlet UILabel *textView;

- (IBAction) authenticateBtn: sender;
- (IBAction) signupBtn: (id)sender;

//-(void)keyboardWillShow:(NSNotification *)notif;
//-(void)keyboardWillHide:(NSNotification *)notif;

@end
