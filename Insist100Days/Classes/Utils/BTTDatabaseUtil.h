//
//  BTTDatabaseUtil.h
//  AA
//
//  Created by qatang on 13-3-18.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface BTTDatabaseUtil : NSObject


@property (nonatomic, strong) FMDatabase *db;

+ (FMDatabase *)connectionFromDatabase;
+ (void)initSchema:(FMDatabase *)db;
+ (int)schemaVersion:(FMDatabase *)db;
+ (void)setSchemaVersion:(FMDatabase *)db version:(NSInteger)version;
+ (void)migrateDB:(FMDatabase *)db fromVersion:(NSInteger)fromVersion toVersion:(NSInteger)toVersion;

+ (BTTDatabaseUtil *)shared;
+ (BOOL)dropTable:(NSString *)tableName;
- (BOOL)establishConnection;
- (BOOL)isTableExist:(NSString *)tableName;

@end
