//
//  TakePhotoViewController.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 5/13/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TakePhotoViewController : UIImagePickerController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
}

- (NSData *)imgToNSData:(UIImage *) image;

@end
