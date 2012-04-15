//
//  HollabackMsg.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "HollabackMsg.h"
#import "Communcations.h"
#import "LFCGzipUtility.h"
#import "MessageQueue.h"
#import "iphone_rightridesAppDelegate.h"
#import "NSStringAdditions.h"

@implementation HollabackMsg

@synthesize image;
@synthesize harrssementType;
@synthesize messageID;
@synthesize comm;

- (void) sendHollback: (Communcations *) c {
	self.comm = c;
	
	//Generate xml
	NSMutableString *xml_string = [[NSMutableString alloc] initWithCapacity: 1024];
	[self generateHollabackXml: xml_string];
	
	//NSLog(@"%@",xml_string);
	
	//Send xml
	NSURL *hollaback_url = [NSURL URLWithString: [NSString stringWithFormat: @"%@%@", self.comm.SERVER, @"/incoming/"] ];
	
	// stop updting the location
	
	// Compress data
	NSData *uncompressedData = [xml_string dataUsingEncoding: NSUTF8StringEncoding];
	NSData *compressedData = [LFCGzipUtility gzipData:uncompressedData];
	NSURLRequest *theRequest = [self.comm postRequestWithURL:hollaback_url
													 boundry:comm.BOUNDRY
														data:compressedData ];
	
	// create the connection with the request
	// and start loading the data
	NSLog(@"message ID %d", self.messageID);
	//msgID = [[NSString alloc] initWithFormat:@"%d", temp];
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		
		receivedData=[[NSMutableData data] retain];
		
	} else {
		// inform the user that the download could not be made
	}
	
	//theConnection.delegate = self;
	
	//[theConnection release];	
}

- (void) generateHollabackXml: (NSMutableString *) xml_string {
	[xml_string setString: @""];
	[xml_string appendString: @"<hollaback>\n"];
	
	double latitude = 0;
	double longitude = 0;
	
	/* Retrieve the GPS information */
	if (self.comm.bestEffortAtLocation == nil){
		latitude = 0;
		longitude = 0;
		
	} else {
		latitude = self.comm.bestEffortAtLocation.coordinate.latitude;
		longitude = self.comm.bestEffortAtLocation.coordinate.longitude;
	}
	
	NSLog(@"longitude: %f \n latitude: %f", longitude, latitude);
	/* Generate Standard Header, includes authentication message */
	NSMutableString *temp_string = [[NSMutableString alloc] init];
	[comm generateStandardHeader: temp_string];
	[xml_string appendString: temp_string];
	[temp_string release];
	
	/* Glue the final message together */
	[xml_string appendString: @"\t<message>\n"];
	
	[xml_string appendString: @"\t\t<gps>\n"];
	
	[xml_string appendString: @"\t\t\t<longitude>\n"];
	[xml_string appendString: @"\t\t\t\t<degrees>"];
	[xml_string appendString: [NSString stringWithFormat:@"%f",longitude]];
	[xml_string appendString: @"</degrees>\n"];
	[xml_string appendString: @"\t\t\t</longitude>\n"];
	
	[xml_string appendString: @"\t\t\t<latitude>\n"];
	[xml_string appendString: @"\t\t\t\t<degrees>"];
	[xml_string appendString: [NSString stringWithFormat:@"%f",latitude]];
	[xml_string appendString: @"</degrees>\n"];
	[xml_string appendString: @"\t\t\t</latitude>\n"];
	
	[xml_string appendString: @"\t\t</gps>\n"];
	
	[xml_string appendString: @"\t\t<title></title>\n"];
	[xml_string appendString: @"\t\t<description></description>\n"];
	[xml_string appendString: @"\t\t<category>"];
	if( harrssementType != Nil )
		[xml_string appendString: harrssementType];
	[xml_string appendString: @"</category>\n"];
	
	// encrypt image to base64
	
	if( self.image != nil ) {
		NSString *imageString = [self dataToBase64:self.image];
		[xml_string appendString: @"\t<images>\n"];
		[xml_string appendString: @"\t\t<image>"];
		if( self.image != Nil )
			NSLog(imageString);
		[xml_string appendString: imageString];
		[xml_string appendString:@"</image>\n"];                                                                                   
		[xml_string appendString: @"\t</images>\n"];
		//[imageString release];
	} else {
		[xml_string appendString: @"\t<images></images>\n"];                                                                                  
	}
	
	
	[xml_string appendString: @"\t</message>\n\n"];
	
	[xml_string appendString: @"</hollaback>\n"];
}


- (NSString *)dataToBase64:(NSData *) img
{
	
	
	//NSData *dataImage = UIImageJPEGRepresentation(image , 0.5);
	
	NSString *encodedString = [[[NSString alloc] init] autorelease];
	encodedString = [NSString base64StringFromData: img length: 1000];
	
	return encodedString;
	
}


#pragma mark -
#pragma mark NSURLConnection Callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    [receivedData setLength:0];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
	
    // append the new data to the receivedData
	
    // receivedData is declared as a method instance elsewhere
	
    [receivedData appendData:data];
	
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
	
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
    // do something with the data
    // receivedData is declared as a method instance elsewhere
	
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString* aStr = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]; //NSASCIIStringEncoding
	
	NSLog(@"%@",aStr);
	
	NSRange range = [aStr rangeOfString: @"<status>okay</status>"];
	
	if (range.location == NSNotFound) {
		//check to see if it was a login error
		range = [aStr rangeOfString: @"Your username and password were incorrect"];
		
		if (range.location != NSNotFound) {
			iphone_rightridesAppDelegate *appDelegate = (iphone_rightridesAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appDelegate authenticationFailed];
		} else {
			NSLog( @"Some strange error" );
		}
	}
	else {
		[self.comm.queue confirmPop: self.messageID];
	}
	
    // release the connection, and the data object
    [connection release];
}

@end
