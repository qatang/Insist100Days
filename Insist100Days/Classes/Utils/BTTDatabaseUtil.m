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
    [db executeUpdate:@"CREATE TABLE btt_task ( \
     task_id INTEGER PRIMARY KEY AUTOINCREMENT, \
     title VARCHAR(20) NOT NULL DEFAULT '', \
     description VARCHAR(512), \
     created_time INTEGER NOT NULL DEFAULT 0, \
     updated_time INTEGER NOT NULL DEFAULT 0, \
     begin_time INTEGER NOT NULL DEFAULT 0, \
     end_time INTEGER NOT NULL DEFAULT 0, \
     status INTEGER NOT NULL DEFAULT 0, \
     current INTEGER NOT NULL DEFAULT 0,\
     checked_days INTEGER NOT NULL DEFAULT 0,\
     total_days INTEGER NOT NULL DEFAULT 0 \
	 )"];

    // create book_item table
    [db executeUpdate:@"CREATE TABLE btt_task_item ( \
     item_id INTEGER PRIMARY KEY AUTOINCREMENT, \
     task_id INTEGER NOT NULL DEFAULT 0, \
     memo VARCHAR(512), \
     created_time INTEGER NOT NULL DEFAULT 0, \
     updated_time INTEGER NOT NULL DEFAULT 0, \
     checked INTEGER NOT NULL DEFAULT 0, \
     currentDays INTEGER NOT NULL DEFAULT 0\
	 )"];

    [self setSchemaVersion:db version:BTT_DB_SCHEMA_VERSION];
    [db commit];
}
@end
