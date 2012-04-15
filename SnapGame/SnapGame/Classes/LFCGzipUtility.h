//
//  LFCGzipUtility.h
//  iphone_rightrides
//
//  Created by Abhinav sharma on 4/12/10.
//  Copyright 2010 Orangmico LLC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "zlib.h"

@interface LFCGzipUtility : NSObject
{
	
}

+(NSData*) gzipData: (NSData*)pUncompressedData;

@end