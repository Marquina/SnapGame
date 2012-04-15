//
//  MessageQueue.h
//  iphone_rightrides
//
//  Created by CÃ©sar on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

@class HollabackMsg;

@interface MessageQueue : NSObject {
	NSMutableArray *messages;
	
	NSLock *db_lock;
	sqlite3 *database;
	sqlite3_stmt *deleteStmt;
	sqlite3_stmt *addStmt;
	sqlite3_stmt *countStmt;
}

- (void) push: (HollabackMsg *)msg;
- (HollabackMsg *) pop;
- (int) size;

- (BOOL) confirmPop: (NSInteger) msgID;
- (int) addMsgToDB:(HollabackMsg *)msg;
- (int) dbMsgCount;

@end
