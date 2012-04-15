//
//  NSStringAdditions.h
//  iphone_rightrides
//
//  Created by Abhinav sharma on 4/9/10.
//  Copyright 2010 Orangmico LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <Foundation/NSString.h>

@interface NSString (NSStringAdditions)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

@end
