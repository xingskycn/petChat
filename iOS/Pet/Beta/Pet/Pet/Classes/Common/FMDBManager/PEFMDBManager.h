//
//  PEFMDBManager.h
//  Pet
//
//  Created by Wuzhiyong on 5/29/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

/************Near View Data委托************/
@protocol PefmdbDelegate <NSObject>

@optional
- (void)selectNearDataSucc:(NSArray *)data;
//消息数据委托
- (void)selectMessageDataSucc:(NSArray *)data;
- (void)selectMessageListSucc:(NSArray *)data;
@end

@interface PEFMDBManager : NSObject


@property (retain, nonatomic) FMDatabase *db;//数据库对象
@property (retain, nonatomic) NSString *docPath;//文件路径

/************委托************/

@property (assign, nonatomic) id <PefmdbDelegate> peFMDBDelegate;

//FMDB单例
+ (PEFMDBManager *)sharedManager;

//检查数据库
- (BOOL)check;
- (BOOL)close;

/************创建数据表************/
//测试
- (BOOL)creatNewTableWithTableName:(NSString *)tableName AndColumns:(NSArray *) columns;

/*************数据库操作：增*************/
//测试
- (BOOL)addDataToTestTable:(NSArray *)dataArray;

/*************数据库操作：删*************/
//测试
- (BOOL)deleteDataforTable:(NSString *)tableName WithColumn:(NSString *)column AndObject:(id)object;

/*************数据库操作：改************/
//测试
- (BOOL)editTable:(NSString *)tableName WithOldData:(NSDictionary *)oldDict AndNewData:(NSDictionary *)newDict;

/*************数据库操作：查************/
//判断表是否存在
- (void)selectTestDataWithObject:(NSString *)object AndColumn:(NSString *)column;



/************select all data from near table************/
- (BOOL)selectAllDataFromNearTable;
- (BOOL)addDataToNearTable:(NSDictionary *)dict;

/*************数据库操作************/
- (BOOL) isTableExisted:(NSString *)tableName;
- (BOOL) eraseTable:(NSString *)tableName;

/********消息数据操作*********/
- (BOOL)addChatMessageToTable :(NSString *)tableName :(NSArray *)dataArray;
- (BOOL)addGroupMessageToTable :(NSString *)tableName :(NSArray *)dataArray;
- (BOOL)selectNeweatMessageFromTableWithToFrom :(NSString *)tableName :(NSString *)to :(NSString *)from;

/********添加最新聊天信息*********/
- (BOOL)insertNewMessageToTable:(NSString *)tableName :(NSString *)date :(NSString *)type :(NSString *)nickName :(NSString *)from;
- (BOOL)selectNewMessageListFromTable:(NSString *)tableName;
@end



