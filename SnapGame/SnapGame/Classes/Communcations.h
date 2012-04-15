//
//  Communcations.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class HollabackMsg;
@class Communcations;
@class MessageQueue;

@protocol CommuncationsCallbacks
@optional
- (void) communcationCallback: (Communcations *)comm status: (NSString *) st response: (NSString *) msg;
@end

@interface Communcations : NSObject <CLLocationManagerDelegate> {
	BOOL userAuthenticated;
	NSMutableData *receivedData;
	
	id<CommuncationsCallbacks> delegate;
	
	NSMutableArray *locationMeasurements;
	CLLocation *bestEffortAtLocation;
	
	MessageQueue *queue;
	NSThread *hollabackSendThread;
	
	NSString * BOUNDRY;
	NSString * SERVER;
}

@property (readonly, nonatomic) BOOL userAuthenticated;
@property (assign) id<CommuncationsCallbacks> delegate;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;
@property (retain) NSString * SERVER;
@property (retain) NSString * BOUNDRY;
@property (readonly) MessageQueue *queue;

- (id) init;
- (void) runThread;

#pragma mark -
#pragma mark Request
- (void) queueHollaback: (HollabackMsg *) hmsg;
- (void) sendHollback: (HollabackMsg *) hmsg;
- (void) authenticateUser:(NSString *) username password: (NSString *) pwd;
- (void) signupUser:(NSString *) username password: (NSString *) pwd email:(NSString *) email;
- (NSURLRequest *)postRequestWithURL: (NSURL *)url boundry: (NSString *)boundry data: (NSData *)data;

#pragma mark -
#pragma mark Generate Xml request

- (void) generateStandardHeader: (NSMutableString *) xml_string;
- (void) generatAuthenticationXml:(NSMutableString *) xml_string user: (NSString *) user_name password: (NSString *) pwd;
- (void) generatSignupXml:(NSMutableString *) xml_string user: (NSString *) user_name password: (NSString *) pwd email:(NSString *) email;
//- (void) generateHollabackXml: (NSMutableString *) xml_string hollabackmsg: (HollabackMsg *) hmsg;


#pragma mark -
#pragma mark Web Communcations

- (void) sendHollaback: (NSData *) data;

#pragma mark -
#pragma mark Encryption Routines

- (void)testAsymmetricEncryptionAndDecryption;
- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer;
- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer;
- (SecKeyRef)getPublicKeyRef;
- (SecKeyRef)getPrivateKeyRef;
+ (NSString *)dataToBase64:(NSData *)data;

@end

