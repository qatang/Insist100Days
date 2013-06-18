//
//  BTTDatabaseUtil.m
//  AA
//
//  Created by qatang on 13-3-18.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import "BTTDatabaseUtil.h"
#import "BTTConfig.h"
#import "BTTLogger.h"

@implementation BTTDatabaseUtil

+ (FMDatabase *)connectionFromDatabase
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:BTT_DB_FILENAME];
//
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    if (![db open]) {
//        //LNLOG_ERROR(@"Open database failed, location is: %@", dbPath);
//        return nil;
//    }

    return self.shared.db;
}

@synthesize db;

- (id)init {
    if (self = [super init]) {
        [self establishConnection];
    }
    return self;
}

+ (BTTDatabaseUtil *)shared {
    static BTTDatabaseUtil *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (BOOL)establishConnection{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:BTT_DB_FILENAME];
    if(!dbPath){
//        BTTLOG_ERROR(@"dbpath MUST be set.");
        return NO;
    } else {
        self.db = [FMDatabase databaseWithPath:dbPath];
        if(![self.db open]){
//            BTTLOG_ERROR(@"Failed to establish connection to %@", dbPath);
        } else {
//            BTTLOG_INFO(@"Connection established to %@", dbPath);
        }

        self.db.logsErrors = YES;
        return YES;
    }
}

+ (BOOL)dropTable:(NSString *)tableName {
    NSString *queryString = [NSString stringWithFormat:@"DROP TABLE %@;", tableName];

    [self.shared.db closeOpenResultSets];

    if([self.shared.db executeUpdate:queryString]){
        return YES;
    }
    else{
        // todo
    }
    return NO;
}

- (BOOL)isTableExist:(NSString *)tableName {

    FMResultSet *rs = [self.db executeQuery:@"select [sql] from sqlite_master where [type] = 'table' and lower(name) = ?", tableName];

    //if at least one next exists, table exists
    BOOL returnBool = [rs next];

    //close and free object
    [rs close];

    return returnBool;
}

+ (int)schemaVersion:(FMDatabase *)db
{
    FMResultSet *resultSet = [db executeQuery:@"PRAGMA user_version"];
    int version = 0;
    if ([resultSet next]) {
        version = [resultSet intForColumnIndex:0];
    }
    return version;
}

+ (void)setSchemaVersion:(FMDatabase *)db version:(NSInteger)version
{
    // FMDB cannot execute this query because FMDB tries to use prepared statements
    sqlite3_exec(db.sqliteHandle, [[NSString stringWithFormat:@"PRAGMA user_version = %d", version] UTF8String], nil, nil, nil);
}

+ (void)migrateDB:(FMDatabase *)db fromVersion:(NSInteger)fromVersion toVersion:(NSInteger)toVersion
{
    // allow migrations to fall thru switch cases to do a complete run
    // start with current version + 1
	if (toVersion >= fromVersion) {
		return;
    }
	NSInteger ver = fromVersion;
	do {
		ver++;
		[db beginTransaction];
		switch (ver) {
			case 1:
//				sqlite3_exec(db.sqliteHandle, [[NSString stringWithFormat:@"ALTER TABLE ln_notes ADD date_created INTEGER NOT NULL DEFAULT 0"] UTF8String], nil, nil, nil);
//				sqlite3_exec(db.sqliteHandle, [[NSString stringWithFormat:@"ALTER TABLE ln_notes ADD date_updated INTEGER NOT NULL DEFAULT 0"] UTF8String], nil, nil, nil);

				break;
			case 2:
//				sqlite3_exec(db.sqliteHandle, [[NSString stringWithFormat:@"ALTER TABLE ln_notes ADD latitude DOUBLE NOT NULL DEFAULT 0"] UTF8String], nil, nil, nil);
//				sqlite3_exec(db.sqliteHandle, [[NSString stringWithFormat:@"ALTER TABLE ln_notes ADD longitude DOUBLE NOT NULL DEFAULT 0"] UTF8String], nil, nil, nil);

				break;
			default:
				break;
		}
		[self setSchemaVersion:db version:ver];
	} while ([db commit]);
}

+ (void)initSchema:(FMDatabase *)db
{
    [db beginTransaction];

    // create book table
    [db executeUpdate:@"CREATE TABLE btt_book ( \
     book_id INTEGER PRIMARY KEY AUTOINCREMENT, \
     name VARCHAR(512) NOT NULL DEFAULT '', \
     description VARCHAR(512), \
     date_created INTEGER NOT NULL DEFAULT 0, \
     date_updated INTEGER NOT NULL DEFAULT 0, \
     begin_date INTEGER NOT NULL DEFAULT 0, \
     end_date INTEGER NOT NULL DEFAULT 0, \
     total_income DOUBLE NOT NULL DEFAULT 0,\
     total_expenditure DOUBLE NOT NULL DEFAULT 0,\
     total_balance DOUBLE NOT NULL DEFAULT 0,\
     background_img VARCHAR(512),\
     current INTEGER NOT NULL DEFAULT 0,\
     status INTEGER NOT NULL DEFAULT 0 \
	 )"];

    // create book_item table
    [db executeUpdate:@"CREATE TABLE btt_book_item ( \
     book_item_id INTEGER PRIMARY KEY AUTOINCREMENT, \
     book_id INTEGER NOT NULL DEFAULT 0, \
     book_item_type INTEGER NOT NULL DEFAULT 0, \
     content VARCHAR(512), \
     date_created INTEGER NOT NULL DEFAULT 0, \
     date_updated INTEGER NOT NULL DEFAULT 0, \
     current_day INTEGER NOT NULL DEFAULT 0, \
     consume_type INTEGER NOT NULL DEFAULT 0, \
     settle_type INTEGER NOT NULL DEFAULT 0,\
     amount DOUBLE NOT NULL DEFAULT 0,\
     img VARCHAR(512),\
     lbs VARCHAR(512),\
     lat VARCHAR(512),\
     lng VARCHAR(512),\
     province VARCHAR(512),\
     city VARCHAR(512),\
     county VARCHAR(512),\
     locked INTEGER NOT NULL DEFAULT 0\
	 )"];

    // create book_item_detail table
    [db executeUpdate:@"CREATE TABLE btt_book_item_detail ( \
     book_item_detail_id INTEGER PRIMARY KEY AUTOINCREMENT, \
     book_item_id INTEGER NOT NULL DEFAULT 0, \
     member_id INTEGER NOT NULL DEFAULT 0, \
     member_name VARCHAR(512), \
     date_created INTEGER NOT NULL DEFAULT 0, \
     date_updated INTEGER NOT NULL DEFAULT 0, \
     amount DOUBLE NOT NULL DEFAULT 0\
	 )"];

    [db executeUpdate:@"CREATE TABLE btt_user ( \
     user_id INTEGER PRIMARY KEY AUTOINCREMENT, \
     name VARCHAR(512), \
     avatar VARCHAR(512), \
     role INTEGER NOT NULL DEFAULT 0, \
     source INTEGER NOT NULL DEFAULT 0, \
     source_nickname VARCHAR(512), \
     source_account VARCHAR(512), \
     date_created INTEGER NOT NULL DEFAULT 0, \
     date_updated INTEGER NOT NULL DEFAULT 0 \
	 )"];

    [db executeUpdate:@"CREATE TABLE btt_book_user ( \
     book_user_id INTEGER PRIMARY KEY AUTOINCREMENT, \
     book_id INTEGER NOT NULL DEFAULT 0, \
     user_id INTEGER NOT NULL DEFAULT 0, \
     user_name VARCHAR(512) NOT NULL DEFAULT '', \
     status INTEGER NOT NULL DEFAULT 0, \
     amount DOUBLE NOT NULL DEFAULT 0,\
     date_created INTEGER NOT NULL DEFAULT 0, \
     date_updated INTEGER NOT NULL DEFAULT 0 \
	 )"];

	[self setSchemaVersion:db version:BTT_DB_SCHEMA_VERSION];
    [db commit];
}

@end
