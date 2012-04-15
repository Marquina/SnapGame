//
//  Communcations.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 3/7/10.
//


#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include <CommonCrypto/CommonCryptor.h>
#import "Communcations.h"
#import "HollabackMsg.h"
#import "LFCGzipUtility.h"
#import "MessageQueue.h"
#import "NSStringAdditions.h"
#import "iphone_rightridesAppDelegate.h"

SecKeyRef privateKey = NULL; //TODO:
SecKeyRef publicKey = NULL; //TODO: 
SecKeyRef publicTag = NULL; //TODO:
SecKeyRef privateTag = NULL; //TODO: 

@implementation Communcations

static NSString * const FORM_FLE_INPUT = @"hollabackposting";
//NSString *msgID;

@synthesize userAuthenticated;
@synthesize delegate;
@synthesize locationMeasurements;
@synthesize bestEffortAtLocation;
@synthesize SERVER; 
@synthesize BOUNDRY;
@synthesize queue;


- (id) init {
	userAuthenticated = NO;
	queue = [[MessageQueue alloc] init];
	
	self.BOUNDRY = @"0xKhTmLbOuNdArY";
#ifndef NDEBUG
	/* Debug only code */   
	//self.SERVER = @"http://192.168.178.28:8000";
	//static NSString * const SERVER = @"http://127.0.0.1:8000";
	//self.SERVER = @"http://10.0.0.4:8000";
	self.SERVER = @"http://backend.ihollaback.com";
	//self.SERVER = @"http://ferrari.dreamhost.com:8000";
#else
	//self.SERVER = @"http://192.168.178.28:8000";
	self.SERVER = @"http://backend.ihollaback.com";
	//self.SERVER = @"http://ferrari.dreamhost.com:8000";
#endif
	
	[NSThread detachNewThreadSelector: @selector(runThread) toTarget:self withObject:nil];
	
	return self;
}

- (void) runThread { 
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[NSThread sleepForTimeInterval: 0.2];
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	while( YES ) {
		//no need to retain, since we will use it here and never again
		HollabackMsg *msg = [queue pop]; 
		
		if( msg != nil 
		   && [appDel.prefs objectForKey:@"username"] != nil
		   && [appDel.prefs objectForKey:@"password"] != nil) {
			[self performSelectorOnMainThread:@selector(sendHollback:)  withObject:msg waitUntilDone:YES];
			[NSThread sleepForTimeInterval: 5.0];
		} else {
			[NSThread sleepForTimeInterval: 5.0];
		}
	}
	[pool release];
}

- (void) queueHollaback: (HollabackMsg *) hmsg {
	[queue push: hmsg];
}

#pragma mark -
#pragma mark Generate Xml Request

- (void) authenticateUser:(NSString *) username password: (NSString *) pwd {
	//Generate xml
	NSMutableString *xml_string = [[NSMutableString alloc] initWithCapacity: 1024];
	[self generatAuthenticationXml: xml_string user:username password: pwd];
	
	//Send xml
	NSString *url_string = [NSString stringWithFormat: @"%@%@", SERVER, @"/authenticate/"];
	NSURL *hollaback_url = [NSURL URLWithString: url_string];
	
	NSURLRequest *theRequest = [self postRequestWithURL:hollaback_url
												boundry:BOUNDRY
												   data:[xml_string dataUsingEncoding: NSUTF8StringEncoding] ];
	
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	//	msgID = [[NSString alloc] initWithFormat:@"-1" ];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
	
}

- (void) signupUser:(NSString *) username password: (NSString *) pwd email:(NSString *)email {
	
	//Generate xml
	NSMutableString *xml_string = [[NSMutableString alloc] initWithCapacity: 1024];
	[self generatSignupXml: xml_string user:username password: pwd email: email];
	
	//Send xml
	NSURL *hollaback_url = [NSURL URLWithString: [NSString stringWithFormat: @"%@%@", SERVER, @"/signup/"] ];
	
	NSURLRequest *theRequest = [self postRequestWithURL:hollaback_url
												boundry:BOUNDRY
												   data:[xml_string dataUsingEncoding: NSUTF8StringEncoding] ];
	
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	//	msgID = [[NSString alloc] initWithFormat:@"-1" ];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
}


- (void) sendHollback: (HollabackMsg *) hmsg {
	[hmsg sendHollback: self];
}

//http://stackoverflow.com/questions/125306/how-can-i-upload-a-photo-to-a-server-with-the-iphone
- (NSURLRequest *)postRequestWithURL: (NSURL *)url
							 boundry: (NSString *)boundry
								data: (NSData *)data
{
	// from http://www.cocoadev.com/index.pl?HTTPFileUpload
	NSMutableURLRequest *urlRequest =
	[NSMutableURLRequest requestWithURL:url];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setValue:
	 [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry]
	  forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postData =
	[NSMutableData dataWithCapacity:[data length] + 512];
	[postData appendData:
	 [[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:
	 [[NSString stringWithFormat:
	   @"Content-Disposition: form-data; name=\"%@\"; filename=\"file.bin\"\r\n\r\n", FORM_FLE_INPUT]
	  dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:data];
	[postData appendData:
	 [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	NSString *tempstr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
	NSLog(@"%@",tempstr);
	[tempstr release];
	
	[urlRequest setHTTPBody:postData];
	return urlRequest;
}

#pragma mark -
#pragma mark Generate Xml Request

- (void) generateStandardHeader: (NSMutableString *) xml_string {
	//SOURCE
	UIDevice *device = [UIDevice currentDevice];
	
	iphone_rightridesAppDelegate *appDel = (iphone_rightridesAppDelegate *) UIApplication.sharedApplication.delegate;
	NSString *username = [appDel.prefs objectForKey:@"username"];
	NSString *pwd = [appDel.prefs objectForKey:@"password"];
	
	[xml_string setString: @""];
	[xml_string appendString: @"<header>\n"];
	
	[xml_string appendString: @"\t<username>"];
	[xml_string appendString: username];
	[xml_string appendString: @"</username>\n"];
	[xml_string appendString: @"\t<password>"];
	[xml_string appendString: pwd];
	[xml_string appendString: @"</password>\n"];
	
	[xml_string appendString: @"\t<source>\n"];
	
	[xml_string appendString: @"\t\t<name>"];
	[xml_string appendString: @"iphoneos"];
	[xml_string appendString: @"</name>\n"];
	
	[xml_string appendString: @"\t\t<version>"];
	[xml_string appendString: @"2010.13.26"];
	[xml_string appendString: @"</version>\n"];
	
	[xml_string appendString: @"\t\t<iphone_unique_id>"];
	[xml_string appendString: device.uniqueIdentifier ];
	[xml_string appendString: @"</iphone_unique_id>\n"];
	
	[xml_string appendString: @"\t\t<iphone_model>"];
	[xml_string appendString: device.model];
	[xml_string appendString: @"</iphone_model>\n"];
	
	[xml_string appendString: @"\t\t<iphone_system_name>"];
	[xml_string appendString: device.systemName];
	[xml_string appendString: @"</iphone_system_name>\n"];
	
	[xml_string appendString: @"\t\t<iphone_system_version>"];
	[xml_string appendString: device.systemVersion];
	[xml_string appendString: @"</iphone_system_version>\n"];
	
	[xml_string appendString: @"\t\t<iphone_device_name>"];
	[xml_string appendString: device.name];
	[xml_string appendString: @"</iphone_device_name>\n"];
	
	[xml_string appendString: @"\t</source>\n\n"];
	
	[xml_string appendString: @"</header>\n"];
	
}

- (void) generatAuthenticationXml:(NSMutableString *) xml_string user: (NSString *) user_name password: (NSString *) pwd {
	[xml_string setString: @""];
	[xml_string appendString: @"<hollaback_auth>\n"];
	[xml_string appendString: @"<username>"];
	[xml_string appendString: user_name];
	[xml_string appendString: @"</username>\n"];
	[xml_string appendString: @"<password>"];
	[xml_string appendString: pwd];
	[xml_string appendString: @"</password>\n"];
	[xml_string appendString: @"</hollaback_auth>\n"];
}

- (void) generatSignupXml:(NSMutableString *) xml_string user: (NSString *) user_name password: (NSString *) pwd email: (NSString *) email{
	[xml_string setString: @""];
	[xml_string appendString: @"<hollaback_signup>\n"];
	[xml_string appendString: @"<username>"];
	[xml_string appendString: user_name];
	[xml_string appendString: @"</username>\n"];
	[xml_string appendString: @"<password>"];
	[xml_string appendString: pwd];
	[xml_string appendString: @"</password>\n"];
	[xml_string appendString: @"<email>"];
	[xml_string appendString: email];
	[xml_string appendString: @"</email>\n"];
	[xml_string appendString: @"</hollaback_signup>\n"];
}

#pragma mark -
#pragma mark Web Communcations

//TODO: later use encryption
- (void) sendHollaback: (NSData *) data {
	/*
	 //Build Request
	 NSURL *theURL = [NSURL URLWithString:@"http://localhost:8000/incoming/"];
	 NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
	 [theRequest setHTTPMethod:@"POST"];
	 
	 //[theRequest setValue:@"application/json-rpc" forHTTPHeaderField:@"Content-Type"];
	 NSString *theBodyString = @"some request here";
	 //NSLog(@"%@", theBodyString);
	 NSData *theBodyData = [theBodyString dataUsingEncoding:NSUTF8StringEncoding];
	 //NSLog(@"%@", theBodyData);
	 
	 [theRequest setHTTPBody:theBodyData];
	 
	 //Get Response
	 NSURLResponse *theResponse = NULL;
	 NSError *theError = NULL;
	 //NSData *theResponseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];
	 //NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
	 //NSLog(theResponseString);
	 //NSDictionary *theResponseDictionary = [[CJSONDeserializer deserializer] deserialize:theResponseString];
	 //NSLog(@"%@", theResponseDictionary);
	 //NSString *theGreeting = [theResponseDictionary objectForKey:@"greeting"];
	 //[self setValue:theGreeting forKey:@"greeting"];
	 */
	
}

#pragma mark -
#pragma mark Encryption Routines

//TODO: 

// http://nootech.wordpress.com/2009/01/17/asymmetric-encryption-with-the-iphone-sdk-and-securityframework/

const size_t BUFFER_SIZE = 64;
const size_t CIPHER_BUFFER_SIZE = 1024;
const uint32_t PADDING = kSecPaddingNone;

- (void)testAsymmetricEncryptionAndDecryption {
	
    uint8_t *plainBuffer;
    uint8_t *cipherBuffer;
    uint8_t *decryptedBuffer;
	
    const char inputString[] = "this is a test.  this is only a test.  please remain calm.";
    int len = strlen(inputString);
    // TODO: this is a hack since i know inputString length will be less than BUFFER_SIZE
    if (len > BUFFER_SIZE) len = BUFFER_SIZE-1;
	
    plainBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    decryptedBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
	
    strncpy( (char *)plainBuffer, inputString, len);
	
    NSLog(@"init() plainBuffer: %s", plainBuffer);
    //NSLog(@"init(): sizeof(plainBuffer): %d", sizeof(plainBuffer));
    [self encryptWithPublicKey:(UInt8 *)plainBuffer cipherBuffer:cipherBuffer];
    NSLog(@"encrypted data: %s", cipherBuffer);
    //NSLog(@"init(): sizeof(cipherBuffer): %d", sizeof(cipherBuffer));
    [self decryptWithPrivateKey:cipherBuffer plainBuffer:decryptedBuffer];
    NSLog(@"decrypted data: %s", decryptedBuffer);
    //NSLog(@"init(): sizeof(decryptedBuffer): %d", sizeof(decryptedBuffer));
    NSLog(@"====== /second test =======================================");
	
    free(plainBuffer);
    free(cipherBuffer);
    free(decryptedBuffer);
}

/* Borrowed from:
 * http://developer.apple.com/DOCUMENTATION/Security/Conceptual/CertKeyTrustProgGuide/iPhone_Tasks/chapter_3_section_7.html
 */
- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer
{
    NSLog(@"== encryptWithPublicKey()");
	
    OSStatus status = noErr;
	
    NSLog(@"** original plain text 0: %s", plainBuffer);
	
    size_t plainBufferSize = strlen((char *)plainBuffer);
    size_t cipherBufferSize = CIPHER_BUFFER_SIZE;
	
    NSLog(@"SecKeyGetBlockSize() public = %d", SecKeyGetBlockSize([self getPublicKeyRef]));
    //  Error handling
    // Encrypt using the public.
    status = SecKeyEncrypt([self getPublicKeyRef],
                           PADDING,
                           plainBuffer,
                           plainBufferSize,
                           &cipherBuffer[0],
                           &cipherBufferSize
                           );
    NSLog(@"encryption result code: %d (size: %d)", status, cipherBufferSize);
    NSLog(@"encrypted text: %s", cipherBuffer);
}

- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer
{
    OSStatus status = noErr;
	
    size_t cipherBufferSize = strlen((char *)cipherBuffer);
	
    NSLog(@"decryptWithPrivateKey: length of buffer: %d", BUFFER_SIZE);
    NSLog(@"decryptWithPrivateKey: length of input: %d", cipherBufferSize);
	
    // DECRYPTION
    size_t plainBufferSize = BUFFER_SIZE;
	
    //  Error handling
    status = SecKeyDecrypt([self getPrivateKeyRef],
                           PADDING,
                           &cipherBuffer[0],
                           cipherBufferSize,
                           &plainBuffer[0],
                           &plainBufferSize
                           );
    NSLog(@"decryption result code: %d (size: %d)", status, plainBufferSize);
    NSLog(@"FINAL decrypted text: %s", plainBuffer);
	
}

- (SecKeyRef)getPublicKeyRef {
	/*
	 OSStatus resultCode = noErr;
	 SecKeyRef publicKeyReference = NULL;
	 
	 if(publicKey == NULL) {
	 NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
	 
	 // Set the public key query dictionary.
	 [queryPublicKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
	 [queryPublicKey setObject:publicTag forKey:(id)kSecAttrApplicationTag];
	 [queryPublicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	 [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
	 
	 // Get the key.
	 resultCode = SecItemCopyMatching((CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference);
	 NSLog(@"getPublicKey: result code: %d", resultCode);
	 
	 if(resultCode != noErr)
	 {
	 publicKeyReference = NULL;
	 }
	 
	 [queryPublicKey release];
	 } else {
	 publicKeyReference = publicKey;
	 }
	 
	 return publicKeyReference;
	 */
	return 0x0;
}

- (SecKeyRef)getPrivateKeyRef {
	/*
	 OSStatus resultCode = noErr;
	 SecKeyRef privateKeyReference = NULL;
	 
	 if(privateKey == NULL) {
	 NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
	 
	 // Set the private key query dictionary.
	 [queryPrivateKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
	 [queryPrivateKey setObject:privateTag forKey:(id)kSecAttrApplicationTag];
	 [queryPrivateKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	 [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
	 
	 // Get the key.
	 resultCode = SecItemCopyMatching((CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyReference);
	 NSLog(@"getPrivateKey: result code: %d", resultCode);
	 
	 if(resultCode != noErr)
	 {
	 privateKeyReference = NULL;
	 }
	 
	 [queryPrivateKey release];
	 } else {
	 privateKeyReference = privateKey;
	 }
	 
	 return privateKeyReference;
	 */
	return 0x0;
}

#pragma mark -
#pragma mark NSURLConnection Callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
	
    // this method is called when the server has determined that it
	
    // has enough information to create the NSURLResponse
	
	
	
    // it can be called multiple times, for example in the case of a
	
    // redirect, so each time we reset the data.
	
    // receivedData is declared as a method instance elsewhere
	NSLog(@"checkpoint 9");
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
	
	if (self.delegate != NULL) {
		[delegate communcationCallback:self status: @"error" response: @"Connection failed!"];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
    // do something with the data
    // receivedData is declared as a method instance elsewhere
	
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString* aStr = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]; //NSASCIIStringEncoding
	
	NSLog(@"%@",aStr);
	
	
	NSRange range = [aStr rangeOfString: @"<status>okay</status>"];
	NSRange userExist = [aStr rangeOfString: @"Username already exists"];
	
	if (self.delegate != NULL) {
		if( range.location == NSNotFound ) {
			if (userExist.location == NSNotFound) {
				[delegate communcationCallback:self status: @"error" response: @"authentication failed"];
			} else {
				[delegate communcationCallback:self status: @"error" response: @"Username Already Exist"];
			}
			
		} else {
			userAuthenticated = YES;
			[delegate communcationCallback:self status: @"okay" response: @"authentication passed"];
		}
	}   
	
    // release the connection, and the data object
    [connection release];
    //[receivedData release];
	NSLog(@"msgID releasing");
	//[msgID release];
}

+ (NSString *)dataToBase64:(NSData *)data
{
	
	// currently taking picture from web 
	/*	id path = @"http://www.edopter.com/images_user/ideas/200805/uU5ACg";
	 NSURL *url = [NSURL URLWithString:path];
	 data = [NSData dataWithContentsOfURL:url];
	 */	
	NSString *path = (NSString*)[[NSBundle mainBundle] pathForResource:@"avatar" ofType:@"jpg"];
	
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	
	//UIImage *img = [[UIImage alloc] initWithData:data];
	
	NSData *dataImage = UIImageJPEGRepresentation(img, 0.8);
	
	NSString *encodedString = [[[NSString alloc] init] autorelease];
	encodedString = [NSString base64StringFromData: dataImage length: 1000];
	
	return encodedString;
	
}


#pragma mark Location Manager Interactions 

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // store all of the measurements, just so we can see what kind of data we might receive
	if (locationMeasurements == nil)
		self.locationMeasurements = [NSMutableArray array];
    [locationMeasurements addObject:newLocation];
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= manager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [manager stopUpdatingLocation];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
			// [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
    // update the display with the new location data
    
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [manager stopUpdatingLocation];
    }
}



@end
