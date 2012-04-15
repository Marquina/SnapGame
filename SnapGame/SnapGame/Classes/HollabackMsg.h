//
//  HollabackMsg.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Communcations;

@interface HollabackMsg : NSObject {
	NSData *image;
	NSInteger messageID;
	NSString *harrssementType;
	
	NSMutableData *receivedData;
	Communcations * comm;
}

@property (nonatomic, readwrite, retain) NSData *image;
@property (nonatomic, retain) NSString *harrssementType;
@property (nonatomic) NSInteger messageID;
@property (nonatomic, retain) Communcations * comm;

- (void) sendHollback: (Communcations *) c;
- (void) generateHollabackXml: (NSMutableString *) xml_string;
- (NSString *)dataToBase64:(NSData *) image;

@end
