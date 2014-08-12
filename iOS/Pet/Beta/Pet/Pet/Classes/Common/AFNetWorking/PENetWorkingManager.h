//
//  PENetWorkingManager.h
//  Pet
//
//  Created by Wuzhiyong on 5/29/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <UIButton+AFNetworking.h>

@interface PENetWorkingManager : AFHTTPSessionManager

+ (PENetWorkingManager *)sharedClient;

//start App
- (NSURLSessionDataTask *)startApp:(NSDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;

//login
- (NSURLSessionDataTask *)login:(NSDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;

//register
- (NSURLSessionDataTask *)userRigister:(NSDictionary *)dictionary image:(UIImage *)img completion:(void (^)(NSDictionary *results, NSError *error))completion;

- (NSURLSessionDataTask *)userRigister:(NSDictionary *)dictionary image:(UIImage *)img userImage:(UIImage *)image completion:(void (^)(NSDictionary *results, NSError *error))completion;
- (NSURLSessionDataTask *)confirmUser:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//生成验证码
- (NSURLSessionDataTask *)sendConfirmCode:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//验证验证码的方法
- (NSURLSessionDataTask *)confirmConfirmCode:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//用户设置
- (NSURLSessionDataTask *)userSetting:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//详情界面添加关注
- (NSURLSessionDataTask *)addFocus:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion ;

//详情界面取消关注
- (NSURLSessionDataTask *)cancelFocus:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;


//上传视频:
- (NSURLSessionDataTask *)upLoadVedio:(NSDictionary *)dictionary video:(NSString *)videoPath videoName:(NSString *)videoName completion:(void (^)(NSDictionary *results, NSError *error))completion;

//获取视频列表
- (NSURLSessionDataTask *)getVideoList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//搜索宠聊号，添加好友
- (NSURLSessionDataTask *)addFriendsBySearch:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;
//详情界面拉黑
- (NSURLSessionDataTask *)blockUser:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//编辑资料界面
- (NSURLSessionDataTask *)getEditInfoList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//详情界面取消拉黑
- (NSURLSessionDataTask *)cancelblockUser:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//详情界面拉黑并举报
- (NSURLSessionDataTask *)detailReportUser:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//联系人好友列表
- (NSURLSessionDataTask *)contactList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//联系人关注列表
- (NSURLSessionDataTask *)contactFoucusList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//粉丝列表界面
- (NSURLSessionDataTask *)contactFansFoucusList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;



//按名字搜索
- (NSURLSessionDataTask *)searchByUserName:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//喊话界面----对评论进行回复
- (NSURLSessionDataTask *)shoutResponseToComment:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//联系人---群组
- (NSURLSessionDataTask *)contactsGroup:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//摇一摇界面
- (NSURLSessionDataTask *)shakeList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//摇到的历史界面
- (NSURLSessionDataTask *)shakeHistoryList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//摇到的历史界面清除
- (NSURLSessionDataTask *)shakeHistoryListClear:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//news界面----对评论进行回复
- (NSURLSessionDataTask *)newsResponseToComment:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;
- (NSURLSessionDataTask *)sendNews:(NSDictionary *)dictionary data:(NSArray *)dataArr completion:(void (^)(NSDictionary *results, NSError *error))completion;

//shout界面----发送新状态
- (NSURLSessionDataTask *)sendShout:(NSDictionary *)dictionary data:(NSArray *)dataArr completion:(void (^)(NSDictionary *results, NSError *error))completion;

//群成员列表界面
- (NSURLSessionDataTask *)groupMemberList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//编辑资料界面保存信息
- (NSURLSessionDataTask *)editSaveInfomation:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;
- (NSURLSessionDataTask *)editPetSaveInfomation:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//编辑界面----添加照片
- (NSURLSessionDataTask *)editViewAddPhotos:(NSDictionary *)dictionary data:(NSArray *)dataArr completion:(void (^)(NSDictionary *results, NSError *error))completion;

//编辑资料界面删除照片
- (NSURLSessionDataTask *)editViewDeleteImage:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//编辑资料界面更改密码
- (NSURLSessionDataTask *)editChangeUserPassword:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//联系人关注搜索
- (NSURLSessionDataTask *)focusSearch:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//联系人好友搜索
- (NSURLSessionDataTask *)friendsSearch:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//联系人粉丝搜索
- (NSURLSessionDataTask *)fansSearch:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error))completion;

//near view
- (NSURLSessionDataTask *)nearDataRequest:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;

//nearDetail view
- (NSURLSessionDataTask *)nearDetailDataRequest:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)nearFliterDataRequest:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)fliterDataDataRequest:(NSDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)fliterSubDataRequest:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;

/*********discover view**********/
//discover club
- (NSURLSessionDataTask *)discoverClub:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)discoverClubDetail:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error) )completion;
//discover group
- (NSURLSessionDataTask *)discoverGroup:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)discoverGroupSearch:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)discoverGroupDetail:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *results, NSError *error) )completion;
//discover news
- (NSURLSessionDataTask *)discoverNews:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)discoverNewsAgree:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)discoverNewsComment:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
//discover shout
- (NSURLSessionDataTask *)discoverShout:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)discoverShoutComment:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)discoverShoutAgree:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;
//热门推荐获取id
- (NSURLSessionDataTask *)searchGetDetailWithHot:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion;

/*********chat view**********/
- (NSURLSessionDataTask *)uploadChatImage:(NSMutableDictionary *)dictionary image:(UIImage *)image imageName:(NSString *)name completion:( void (^)(NSDictionary *results, NSError *error) )completion;

//创建群
- (NSURLSessionDataTask *)newRoom:(NSDictionary *)dictionary data:(NSArray *)dataArr completion:(void (^)(NSDictionary *results, NSError *error))completion;
@end
