//
//  PEFMDBManager.m
//  Pet
//
//  Created by Wuzhiyong on 5/29/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEFMDBManager.h"

static NSString* sqlName =DB_DATABASE_NAME;

@implementation PEFMDBManager

@synthesize db, docPath;
@synthesize peFMDBDelegate;

#pragma mark - 
#pragma SINGLE
+ (PEFMDBManager *)sharedManager {
    static PEFMDBManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager =[[PEFMDBManager alloc]init];
        [_sharedManager initClass];
        
    });
    
    return _sharedManager;
}

- (void)initClass {
    docPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    db =[FMDatabase databaseWithPath:[docPath stringByAppendingPathComponent:sqlName]];
    
    if ([db open]) {
        NSLog(@"***********DATABASE CREATE SUCCESS**********\n");
        [db close];
    }else {
        NSLog(@"***********DATABASE ERROR********** \n DATABASE CREATE ERROR!");
    }
//    NSAssert(![db open], @"***********DATABASE ERROR********** \n DATABASE CREATE ERROR!");
}

- (NSString *)appendWithArray:(NSArray *)dataArray {
    //拼装SQL语句
    NSString *arrtitude =@"('";
    
    for (int i =0; i<dataArray.count; i++) {
        NSString *str =[dataArray objectAtIndex:i];
        
        arrtitude =[arrtitude stringByAppendingString:str];
        if (i < dataArray.count-1)
            arrtitude =[arrtitude stringByAppendingString:@"', '"];
        
    }
    arrtitude =[arrtitude stringByAppendingString:@"')"];
    
    return arrtitude;
}

#pragma mark -
#pragma CHECK & CLOSE DATABASE
- (BOOL)check {
    return [db open];
}

- (BOOL)close {
    return [db close];
}

#pragma mark -
#pragma CREATE TABLE WITH TABLENAME AND COLUMNS
- (BOOL)creatNewTableWithTableName:(NSString *)tableName AndColumns:(NSArray *)columns {
    //拼装SQL语句
    NSString *arrtitude =[self appendWithArray:columns];
    
    NSString *sql =[NSString stringWithFormat:@"CREATE TABLE %@ %@", tableName, arrtitude];
    
    return [db executeUpdate:sql];
    
}

#pragma mark -
#pragma ADD DATA WITH OBJECT & COLUMN
- (BOOL)addDataToTestTable:(NSArray *)dataArray;{
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO test ('c1','c2','c3') VALUES (?,?,?)"];
    
    return [db executeUpdate:sql withArgumentsInArray:dataArray];
}

#pragma mark -
#pragma DELETE DATA WITH OBJECT & COLUMN
- (BOOL)deleteDataforTable:(NSString *)tableName WithColumn:(NSString *)column AndObject:(id)object {
    
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", tableName, column];
    
    return [db executeUpdate:sql, object];
}

#pragma mark -
#pragma EDIT DATA WITH OBJECT & COLUMN

- (BOOL)editTable:(NSString *)tableName WithOldData:(NSDictionary *)oldDict AndNewData:(NSDictionary *)newDict {
    NSString *oldColumn =[oldDict allKeys][0];
    NSString *newColumn =[newDict allKeys][0];
    
    NSString *oldData =[oldDict objectForKey:oldColumn];
    NSString *newData =[newDict objectForKey:newColumn];
    
    NSString *sql =[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", tableName, newColumn, oldColumn];
    
    return [db executeUpdate:sql, newData, oldData];
}

#pragma mark -
#pragma SELECT DATA WITH OBJECT &COLUMN

- (void)selectTestDataWithObject:(NSString *)object AndColumn:(NSString *)column {
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM test WHERE %@ = ?", column];
    FMResultSet *rs = [db executeQuery:sql, object];
    
    while ([rs next]) {
        NSLog(@"%@, %@, %@", [rs stringForColumn:@"c1"], [rs stringForColumn:@"c2"],[rs stringForColumn:@"c3"]);
    }
    
}

#pragma mark - 
#pragma mark CHECK TABLE IS EXIST
- (BOOL) isTableExisted:(NSString *)tableName {
    NSString *sql =[NSString stringWithFormat:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?"];
    FMResultSet *rs = [db executeQuery:sql, tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark NEAR VIEW DATA
- (BOOL)selectAllDataFromNearTable {
    //check table
    if (![self check]) {
        NSLog(@"***********DATABASE ERROR********** \n DATABASE OPEN ERROR!");
        return NO;
    }
    
    if (![self isTableExisted:DB_NEARTABLE_NAME]) {
        NSArray *cArray =[NSArray arrayWithObjects:DB_COLUMN_NEAR_PETID,
                          DB_COLUMN_NEAR_PETNAME,
                          DB_COLUMN_NEAR_PETSEX,
                          DB_COLUMN_NEAR_PETAGE,
                          DB_COLUMN_NEAR_PETIMAGEURL,
                          DB_COLUMN_NEAR_PETNICKNAME,
                          DB_COLUMN_NEAR_PETWANTEDTYPE,
                          DB_COLUMN_NEAR_USERNAME,
                          DB_COLUMN_NEAR_USERSEX,
                          DB_COLUMN_NEAR_USERBIRTHDAY,
                          DB_COLUMN_NEAR_USERSIGN,
                          DB_COLUMN_NEAR_USERLCATION,
                          DB_COLUMN_NEAR_USERLASTLOGIIN,
                          DB_COLUMN_NEAR_USERIMAGEURL,
                          DB_COLUMN_NEAR_PETTYPE,
                          DB_COLUMN_NEAR_USERID,
                          nil];
        [self creatNewTableWithTableName:DB_NEARTABLE_NAME AndColumns:cArray];
    }
    
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM %@", DB_NEARTABLE_NAME];
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *dataArray =[[NSMutableArray alloc] init];
    while ([rs next]) {
        NSMutableDictionary *dataDict =[[NSMutableDictionary alloc] init];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_PETID] forKey:DB_COLUMN_NEAR_PETID];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_PETNAME] forKey:DB_COLUMN_NEAR_PETNAME];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_PETSEX] forKey:DB_COLUMN_NEAR_PETSEX];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_PETAGE] forKey:DB_COLUMN_NEAR_PETAGE];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_PETIMAGEURL] forKey:DB_COLUMN_NEAR_PETIMAGEURL];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_PETNICKNAME] forKey:DB_COLUMN_NEAR_PETNICKNAME];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_PETWANTEDTYPE] forKey:DB_COLUMN_NEAR_PETWANTEDTYPE];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_USERNAME] forKey:DB_COLUMN_NEAR_USERNAME];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_USERSEX] forKey:DB_COLUMN_NEAR_USERSEX];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_USERBIRTHDAY] forKey:DB_COLUMN_NEAR_USERBIRTHDAY];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_USERSIGN] forKey:DB_COLUMN_NEAR_USERSIGN];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_USERLCATION] forKey:DB_COLUMN_NEAR_USERLCATION];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_USERLASTLOGIIN] forKey:DB_COLUMN_NEAR_USERLASTLOGIIN];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_USERIMAGEURL] forKey:DB_COLUMN_NEAR_USERIMAGEURL];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_PETTYPE] forKey:DB_COLUMN_NEAR_PETTYPE];
        [dataDict setObject:[rs stringForColumn:DB_COLUMN_NEAR_USERID] forKey:DB_COLUMN_NEAR_USERID];
        
        [dataArray addObject:dataDict];
    }
    
    
    [peFMDBDelegate selectNearDataSucc:dataArray];
    
    [self close];
    return YES;
}

- (BOOL)addDataToNearTable:(NSDictionary *)dict {
    [self check];
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO %@ VALUES (:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@,:%@)", DB_NEARTABLE_NAME,
                    DB_COLUMN_NEAR_PETID,
                    DB_COLUMN_NEAR_PETNAME,
                    DB_COLUMN_NEAR_PETSEX,
                    DB_COLUMN_NEAR_PETAGE,
                    DB_COLUMN_NEAR_PETIMAGEURL,
                    DB_COLUMN_NEAR_PETNICKNAME,
                    DB_COLUMN_NEAR_PETWANTEDTYPE,
                    DB_COLUMN_NEAR_USERNAME,
                    DB_COLUMN_NEAR_USERSEX,
                    DB_COLUMN_NEAR_USERBIRTHDAY,
                    DB_COLUMN_NEAR_USERSIGN,
                    DB_COLUMN_NEAR_USERLCATION,
                    DB_COLUMN_NEAR_USERLASTLOGIIN,
                    DB_COLUMN_NEAR_USERIMAGEURL,
                    DB_COLUMN_NEAR_PETTYPE,
                    DB_COLUMN_NEAR_USERID
                    ];
    
    BOOL result=[db executeUpdate:sql withParameterDictionary:dict];
    [self close];
    return result;
}

#pragma mark -
#pragma mark ERASE TABLE
- (BOOL) eraseTable:(NSString *)tableName {
    [self check];
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![db executeUpdate:sqlstr])
    {
        NSLog(@"Erase table error!");
        
        [self close];
        return NO;
    }
    
    [self close];
    return YES;
}

#pragma mark -
#pragma mark - INSERT MESSAGE DATA
- (BOOL)addChatMessageToTable :(NSString *)tableName :(NSArray *)dataArray{
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO %@ ('%@','%@','%@','%@','%@') VALUES (?,?,?,?,?)",
                    tableName,
                    DB_COLUMN_MSG_DATE,
                    DB_COLUMN_MSG_FROM,
                    DB_COLUMN_MSG_TO,
                    DB_COLUMN_MSG_CONTENT,
                    DB_COLUMN_MSG_NICKNAME
                    ];
    return [db executeUpdate:sql withArgumentsInArray:dataArray];
}

- (BOOL)addGroupMessageToTable :(NSString *)tableName :(NSArray *)dataArray{
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO %@ ('%@','%@','%@','%@','%@') VALUES (?,?,?,?,?)",
                    tableName,
                    DB_COLUMN_MSG_DATE,
                    DB_COLUMN_MSG_FROM,
                    DB_COLUMN_MSG_TO,
                    DB_COLUMN_MSG_CONTENT,
                    DB_COLUMN_MSG_NICKNAME
                    ];
    return [db executeUpdate:sql withArgumentsInArray:dataArray];
}

- (BOOL)selectNeweatMessageFromTableWithToFrom :(NSString *)tableName :(NSString *)to :(NSString *)from {
    //check table
    if (![self check]) {
        NSLog(@"***********DATABASE ERROR********** \n DATABASE OPEN ERROR!");
        return NO;
    }
    
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' OR %@ = '%@' ORDER BY %@ DESC LIMIT 10",
                    tableName,
                    DB_COLUMN_MSG_FROM,
                    from,
                    DB_COLUMN_MSG_TO,
                    to,
                    DB_COLUMN_MSG_DATE
                    ];
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *dataArray =[[NSMutableArray alloc] init];
    while ([rs next]) {
        NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:[[rs stringForColumn:DB_COLUMN_MSG_CONTENT] objectFromJSONString]];
        if ([rs stringForColumn:DB_COLUMN_MSG_NICKNAME]) {
            [dict setObject:[rs stringForColumn:DB_COLUMN_MSG_NICKNAME] forKey:@"nickName"];
        }else {
            [dict setObject:@"" forKey:@"nickName"];
        }
        [dataArray addObject:[dict JSONString]];
    }
    
    
    [peFMDBDelegate selectMessageDataSucc:dataArray];
    
    [self close];
    return YES;
}

//最新聊天记录
- (BOOL)insertNewMessageToTable:(NSString *)tableName :(NSString *)date :(NSString *)type :(NSString *)nickName :(NSString *)from{
    NSArray *dataArray =@[date, from, type, nickName];
    //check table
    if (![self check]) {
        NSLog(@"***********DATABASE ERROR********** \n DATABASE OPEN ERROR!");
        return NO;
    }
    
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",
                    tableName,
                    DB_COLUMN_MSG_FROM,
                    from
                    ];
    FMResultSet *rs = [db executeQuery:sql];
    
    if (![rs next]) {
        NSString *sql =[NSString stringWithFormat:@"INSERT INTO %@ ('%@','%@','%@','%@') VALUES (?,?,?,?)",
                        tableName,
                        DB_COLUMN_MSG_DATE,
                        DB_COLUMN_MSG_FROM,
                        DB_COLUMN_MSG_TYPE,
                        DB_COLUMN_MSG_NICKNAME
                        ];
        return [db executeUpdate:sql withArgumentsInArray:dataArray];
    }else {
        NSString *sql =[NSString stringWithFormat:@"UPDATE %@ SET %@=?, %@=?, %@=?, %@=? WHERE %@=? ",
                        tableName,
                        DB_COLUMN_MSG_DATE,
                        DB_COLUMN_MSG_FROM,
                        DB_COLUMN_MSG_TYPE,
                        DB_COLUMN_MSG_NICKNAME,
                        DB_COLUMN_MSG_FROM
                        ];
        return [db executeUpdate:sql ,date, from, type, nickName, from];
    }
}

- (BOOL)selectNewMessageListFromTable:(NSString *)tableName {
    //check table
    if (![self check]) {
        NSLog(@"***********DATABASE ERROR********** \n DATABASE OPEN ERROR!");
        return NO;
    }
    
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC",
                    tableName,
                    DB_COLUMN_MSG_DATE
                    ];
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *dataArray =[[NSMutableArray alloc] init];
    while ([rs next]) {
        NSMutableDictionary *data =nil;
        data=[[NSMutableDictionary alloc] init];
        [data setObject:[rs stringForColumn:DB_COLUMN_MSG_DATE] forKey:DB_COLUMN_MSG_DATE];
        [data setObject:[rs stringForColumn:DB_COLUMN_MSG_FROM] forKey:DB_COLUMN_MSG_FROM];
        [data setObject:[rs stringForColumn:DB_COLUMN_MSG_TYPE] forKey:DB_COLUMN_MSG_TYPE];
        [data setObject:[rs stringForColumn:DB_COLUMN_MSG_NICKNAME] forKey:DB_COLUMN_MSG_NICKNAME];
        [dataArray addObject:data];
    }
    
    
    [peFMDBDelegate selectMessageListSucc:dataArray];
    
    [self close];
    return YES;
}

@end
