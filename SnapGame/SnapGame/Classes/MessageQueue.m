//
//  MessageQueue.m
//  iphone_rightrides
//
//  Created by CÃ©sar on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageQueue.h"
#import <sqlite3.h>
#import "iphone_rightridesAppDelegate.h"
#import "HollabackMsg.h"
#import "MainInterface.h"

extern int numOfmsgs;

@implementation MessageQueue

- (id) init {
	messages = [[NSMutableArray alloc] init];
	
	iphone_rightridesAppDelegate *appDelegate = (iphone_rightridesAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *dbPath = [appDelegate getDBPath];
	
	db_lock = [[NSLock alloc] init];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "select MessageID, harassment_type, image from hollaback";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				HollabackMsg *msg = [[HollabackMsg alloc] init];
				msg.messageID = sqlite3_column_int(selectstmt, 0);
				msg.harrssementType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				//msg.image =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
				msg.image = [NSData dataWithBytes:(const void *)sqlite3_column_blob(selectstmt, 2) length:(NSUInteger)sqlite3_column_bytes(selectstmt, 2)];
				[msg retain];
				[messages insertObject:msg atIndex:0];
			}
		}
		sqlite3_finalize( selectstmt );
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
	
	return self;
}

- (void) push: (HollabackMsg *)msg {
	@synchronized( messages ) {
		[msg retain];
		msg.messageID = [self addMsgToDB: msg];
		[messages insertObject: msg atIndex:0];
	}
}

- (HollabackMsg *) pop {
	HollabackMsg *msg = nil;
	@synchronized( messages ) {
		int count = [messages count];
		if( count > 0 ) {
			msg = [messages lastObject];
			[messages removeLastObject];
			[msg release];
		}
	}
	return msg;
}

- (int) size {
	int i = 0;
	@synchronized( messages ) {
		i = [messages count];
	}
	return i;
}

- (BOOL) confirmPop: (NSInteger)msgID {
	iphone_rightridesAppDelegate *appDelegate = (iphone_rightridesAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	@synchronized(db_lock) {
		if(deleteStmt == nil) {
			const char *sql = "delete from hollaback where MessageID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		}
		
		NSLog(@"confirmPop: msgid int value : %d", msgID);
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_int(deleteStmt, 1, msgID);
		
		if (SQLITE_DONE != sqlite3_step(deleteStmt))
			NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(deleteStmt);
		
		if( appDelegate.mainInterface != Nil ) {
			[appDelegate.mainInterface updateMessagesInQueue];
			[appDelegate.mainInterface.view setNeedsDisplay];
		}
		
		return NO;
	}
}

- (int) addMsgToDB:(HollabackMsg *)msg {
	@synchronized(db_lock) {
		int messageID = -1;
		
		if(addStmt == nil) {
			const char *sql = "insert into hollaback(harassment_type, image) Values(?, ?)";
			if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(addStmt, 1, [msg.harrssementType UTF8String], -1, SQLITE_TRANSIENT);
		
		if( msg.image == Nil )
			sqlite3_bind_blob(addStmt, 2, nil, -1, SQLITE_TRANSIENT);
		else
			sqlite3_bind_blob(addStmt, 2, [msg.image bytes], [msg.image length], SQLITE_TRANSIENT);
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		else
			//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
			messageID = sqlite3_last_insert_rowid(database);
		
		//Reset the add statement.
		sqlite3_reset(addStmt);
		
		//int c = [self dbMsgCount];
		
		return messageID;
	}
}


- (int) dbMsgCount {
	@synchronized(db_lock) {
		int count = 0;
		if (countStmt == nil) {
			const char *sql = "SELECT COUNT(*) FROM hollaback";
			if(sqlite3_prepare_v2(database, sql, -1, &countStmt, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		
		if(sqlite3_step(countStmt) == SQLITE_ROW) {
			// Read the data from the result row
			count = (int)sqlite3_column_int(countStmt, 0);
		}
		
		NSLog(@"dbMsgCount: count int value : %d", count);
		sqlite3_reset(countStmt);
		return count;
	}
	
}

//TODO: implement dealloc

-(void) dealloc {
	sqlite3_close(database);
	[super dealloc];
}

@end
