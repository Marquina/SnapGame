//
//  UserSignupViewController.h
//  iphone_rightrides
//
//  Created by Abhinav sharma on 4/30/10.
//  Copyright 2010 Orangmico LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communcations.h"

@interface UserSignupViewController : UIViewController  <CommuncationsCallbacks, UITextFieldDelegate>  {
	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	
	IBOutlet UITextField *email;
	IBOutlet UITextField *email_confirm;
	
	IBOutlet UILabel *statuslabel;
	IBOutlet UIActivityIndicatorView *activityView;
	
	IBOutlet UIView *headerView;
	IBOutlet UIView *mainView;
	
	
	IBOutlet UIButton *backBtn;
}

@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *email_confirm;
@property (nonatomic, retain) IBOutlet UIButton *backBtn;
//@property (nonatomic, retain) IBOutlet UITextField *firstname;

-(IBAction)signupButton:(id)sender;
-(IBAction)backButton:(id)sender;

-(void)keyboardWillShow:(NSNotification *)notif;
-(void)keyboardWillHide:(NSNotification *)notif;

@end
