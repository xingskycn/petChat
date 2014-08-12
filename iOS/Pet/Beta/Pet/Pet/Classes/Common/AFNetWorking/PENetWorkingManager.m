//
//  PENetWorkingManager.m
//  Pet
//
//  Created by Wuzhiyong on 5/29/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENetWorkingManager.h"
#import "JSONKit.h"

@implementation PENetWorkingManager

#pragma mark - 
#pragma SINGLE MODEL

//创建单例
+ (PENetWorkingManager *)sharedClient {
    static PENetWorkingManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, DIR_PATH]];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0"}];
        
        //        //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:0 * 1024 * 1024
                                                          diskCapacity:0 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        
        _sharedClient = [[PENetWorkingManager alloc] initWithBaseURL:baseURL
                                                 sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}


#pragma mark -
#pragma START APP REQUEST

//启动app
- (NSURLSessionDataTask *)startApp:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_START_APP:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:START_APP_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}


#pragma mark -
#pragma mark LOGIN REQUEST
//登陆
- (NSURLSessionDataTask *)login:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_LOGIN:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:LOGIN_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//生成验证码的方法
- (NSURLSessionDataTask *)sendConfirmCode:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_SENDCONFIRMCODE:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:SENDCONFIRMCODE_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//验证验证码的方法
- (NSURLSessionDataTask *)confirmConfirmCode:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_CONFIRMCONFIRMCODE:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONFIRMCONFIRMCODE_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//注册:
//- (NSURLSessionDataTask *)userRigister:(NSDictionary *)dictionary image:(UIImage *)img completion:(void (^)(NSDictionary *, NSError *))completion {
//    NSDictionary *registerDic =@{REQUEST_KEY_REGISTER:[dictionary JSONString]};
//    
//    NSData *imageData =UIImageJPEGRepresentation(img, 0.5);
//    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    self.requestSerializer.timeoutInterval =10.0f;
//    
//    NSURLSessionDataTask *task = [self POST:REGISTER_URL parameters:registerDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imageData name:@"register_uploadUserImage" fileName:@"pet0.jpg" mimeType:@"image/jpeg"];
//        
//        //一张图片对应一个key,多张图片多个key。 name:@"key" fileName:@"图片名"
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(responseObject, nil);
//        });
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(nil, error);
//        });
//    }];
//    
//    return task;
//}

//注册:
- (NSURLSessionDataTask *)userRigister:(NSDictionary *)dictionary image:(UIImage *)img userImage:(UIImage *)image completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *registerDic =@{REQUEST_KEY_REGISTER:[dictionary JSONString]};
    
    NSData *petImageData =UIImageJPEGRepresentation(img, 0.5);
    NSData *userImageData = UIImageJPEGRepresentation(image, 0.5);
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:REGISTER_URL parameters:registerDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {//一张图片对应一个key,多张图片多个key。 name:@"key" fileName:@"图片名"
        [formData appendPartWithFileData:petImageData name:@"register_uploadPetImage" fileName:@"user.jpg" mimeType:@"image/jpeg"];//用户图片
        [formData appendPartWithFileData:userImageData name:@"register_uploadUserImage" fileName:@"pet.jpg" mimeType:@"image/jpeg"];//
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//检测用户是否已经注册
- (NSURLSessionDataTask *)confirmUser:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_CONFIRMUSER:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONFIRMUSER_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

#pragma mark -
#pragma mark - NEAR VIEW REQUEST

//附近数据请求
- (NSURLSessionDataTask *)nearDataRequest:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *nearDict =@{REQUEST_KEY_NEAR:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:NEAR_URL parameters:nearDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
    
}


//near自定义删选
- (NSURLSessionDataTask *)nearFliterDataRequest:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *nearDict =@{REQUEST_KEY_NEAR_FLITER:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:NEAR_FLITER_URL parameters:nearDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
    
}

- (NSURLSessionDataTask *)fliterDataDataRequest:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *nearDict =@{REQUEST_KEY_FLITER_DATA:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:FLITER_DATA_URL parameters:nearDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

- (NSURLSessionDataTask *)fliterSubDataRequest:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *nearDict =@{REQUEST_KEY_FLITER_SUB_DATA:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:FLITER_SUB_DATA_URL parameters:nearDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

#pragma mark -
#pragma mark NEAR DETAIL VIEW REQUEST
- (NSURLSessionDataTask *)nearDetailDataRequest:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *nearDeatilDict =@{REQUEST_KEY_NEARDETAIL:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:NEARDETAIL_URL parameters:nearDeatilDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

#pragma mark - 
#pragma mark DISCOVER GROUP
//热门推荐获取id
- (NSURLSessionDataTask *)searchGetDetailWithHot:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *nearDeatilDict =@{REQUEST_KEY_DISCOVER_GROUP_SEARCH_HOT:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_SEARCH_HOT_URL parameters:nearDeatilDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}


//discover club
- (NSURLSessionDataTask *)discoverClub:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_CLUB:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_CLUB_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

- (NSURLSessionDataTask *)discoverClubDetail:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_CLUBDETAIL:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_CLUBDETAIL_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//discover group
- (NSURLSessionDataTask *)discoverGroup:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_GROUP:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_GROUP_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//群组搜索
- (NSURLSessionDataTask *)discoverGroupSearch:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_GROUP_SEARCH:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_GROUP_SEARCH_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

- (NSURLSessionDataTask *)discoverGroupDetail:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_GROUPDETAIL:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_GROUPDETAIL_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//discover news
- (NSURLSessionDataTask *)discoverNews:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *nearDeatilDict =@{REQUEST_KEY_DISCOVER_NEWS:[dictionary JSONString]};//Api的接口
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_NEWS_URL parameters:nearDeatilDict success:^(NSURLSessionDataTask *task, id responseObject) {//填写具体的url
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//discover news agree
- (NSURLSessionDataTask *)discoverNewsAgree:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_NEWS_AGREE:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_NEWS_AGREE_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//discover news comment
- (NSURLSessionDataTask *)discoverNewsComment:(NSMutableDictionary *)dictionary completion:( void (^)(NSDictionary *results, NSError *error) )completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_NEWS_COMMENT:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_NEWS_COMMENT_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//discover shout
- (NSURLSessionDataTask *)discoverShout:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_SHOUT:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_SHOUT_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

- (NSURLSessionDataTask *)discoverShoutAgree:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_SHOUT_AGREE:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_SHOUTAGREE_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

- (NSURLSessionDataTask *)discoverShoutComment:(NSMutableDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *requestDict =@{REQUEST_KEY_DISCOVER_SHOUT_COMMENT:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DISCOVER_SHOUTCOMMENT_URL parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//用户设置
- (NSURLSessionDataTask *)userSetting:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KET_USERSETTING:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:USERSETTING_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//添加好友界面----搜素号码添加好友
- (NSURLSessionDataTask *)addFriendsBySearch:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_SEARCHFRIENDDS:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:ADDFRIENDSBYSEARCH_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//详情界面添加关注
- (NSURLSessionDataTask *)addFocus:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_ADDFOCUS:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:ADDFOCUS_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//详情界面取消关注
- (NSURLSessionDataTask *)cancelFocus:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_CANCELFOCUS:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CANCELFOCUS_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//详情界面拉黑
- (NSURLSessionDataTask *)blockUser:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_BLOCKUSER:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:BLOCK_USER_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//上传视频:
- (NSURLSessionDataTask *)upLoadVedio:(NSDictionary *)dictionary video:(NSString *)videoPath videoName:(NSString *)videoName completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *registerDic =@{REQUEST_KEY_UPLOADVIDEO:[dictionary JSONString]};
    
    NSData *videoData =[NSData dataWithContentsOfFile:videoPath];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:UPLOAD_VIDEO_URL parameters:registerDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:videoData name:@"upload_video" fileName:videoName mimeType:@"video/mp4"];
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//获取视频列表
- (NSURLSessionDataTask *)getVideoList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_GETVIDEOLIST:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:GETVIDEOLIST_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//编辑资料界面
- (NSURLSessionDataTask *)getEditInfoList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_EDITINFOLIST:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:EDITINFOLIST_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

#pragma mark - CHAT VIEW
//上传聊天图片
- (NSURLSessionDataTask *)uploadChatImage:(NSMutableDictionary *)dictionary image:(UIImage *)image imageName:(NSString *)name completion:(void (^)(NSDictionary *, NSError *))completion {
    NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
    NSDictionary *imgDict =@{REQUEST_KEY_CHAT_ADD_IMAGE:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task =[self POST:CHAT_CHAT_UPLOAD_IMAGE_URL parameters:imgDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"chatting_images" fileName:name mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        }
                       );
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        }
                       );
    }];
    
    return task;
}

//详情界面取消拉黑
- (NSURLSessionDataTask *)cancelblockUser:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_CANCELBLOCKUSER:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CANCELBLOCKUSER_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//详情界面拉黑并举报
- (NSURLSessionDataTask *)detailReportUser:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_DETAILREPORTUSER:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:DETAILREPORTUSER_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}


//联系人好友列表
- (NSURLSessionDataTask *)contactList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_CONTACTLIST:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONTACTLIST_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//关注列表
- (NSURLSessionDataTask *)contactFoucusList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_FOUCUSLIST:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONTACT_FOUCUSLIST_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//粉丝列表
- (NSURLSessionDataTask *)contactFansFoucusList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_CONTACTFANSLIST:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONTACT_FANSLIST_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//按名字搜索
- (NSURLSessionDataTask *)searchByUserName:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_SEARCHBYUSERNAEM:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:SEARCH_BYUSERNAME_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//喊话界面----对评论进行回复
- (NSURLSessionDataTask *)shoutResponseToComment:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_SHOUTRESPONSETOCOMMENT:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:SHOUT_RESPONSETOCOMMENT_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//联系人---群组
- (NSURLSessionDataTask *)contactsGroup:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_CONTACTSGROUP:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONTACTS_GROUP_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}


//摇一摇界面
- (NSURLSessionDataTask *)shakeList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_SHAKELIST:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:SHAKE_LIST_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//摇到的历史界面
- (NSURLSessionDataTask *)shakeHistoryList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_SHAKEHISTORY_LIST:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:SHAKE_HISTORYLIST_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}


//摇到的历史界面清除
- (NSURLSessionDataTask *)shakeHistoryListClear:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_SHAKEHISTORYLIST_CLEAR:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:SHAKE_HISTORYLIST_CLEAR_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//news界面----对评论进行回复
- (NSURLSessionDataTask *)newsResponseToComment:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_NEWSRESPONSETOCOMMENT:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:SHAKE_NEWSRERSPONSETOCOMMENT_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    
    return task;
}

//news界面----发送新状态
- (NSURLSessionDataTask *)sendNews:(NSDictionary *)dictionary data:(NSArray *)dataArr completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEAT_KEY_NEWS_SENDNEWS:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:NEWS_SEND_NEW_URL parameters:startAppDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //取出数据
        for (NSDictionary *data in dataArr) {
            if ([[data objectForKey:@"type"] isEqualToString:@"image"]) {
                UIImage *image =[data objectForKey:@"image"];
                NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:REQUEST_KEY_NEWS_SENDPHOTO fileName:@"test.jpg" mimeType:@"image/jpeg"];
            }else{
                NSString *videoPath =[data objectForKey:@"url"];
                NSData *videoData =[NSData dataWithContentsOfFile:videoPath];
                [formData appendPartWithFileData:videoData name:REQUEST_KEY_NEWS_SENDPHOTO fileName:@"test.mp4" mimeType:@"video/mp4"];
            }
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
    }];
    return task;
}


//shout界面----发送新状态
- (NSURLSessionDataTask *)sendShout:(NSDictionary *)dictionary data:(NSArray *)dataArr completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_SHOUT_SENNEWS:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:SHOUT_SENDNEWS_URL parameters:startAppDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //取出数据
        for (NSDictionary *data in dataArr) {
            if ([[data objectForKey:@"type"] isEqualToString:@"image"]) {
                UIImage *image =[data objectForKey:@"image"];
                NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:REQUEST_KEY_SHOUT_SENDNEWSPHOTO fileName:@"test.jpg" mimeType:@"image/jpeg"];
            }else{
                NSString *videoPath =[data objectForKey:@"url"];
                NSData *videoData =[NSData dataWithContentsOfFile:videoPath];
                [formData appendPartWithFileData:videoData name:REQUEST_KEY_SHOUT_SENDNEWSPHOTO fileName:@"test.mp4" mimeType:@"video/mp4"];
            }
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    return task;
}

//群成员列表界面
- (NSURLSessionDataTask *)groupMemberList:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_GROUPMEMBERLIST:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:GROUP_MEMBERLIST_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}


//编辑资料界面保存信息
- (NSURLSessionDataTask *)editSaveInfomation:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_EDITSAVEINFOMATION:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:EDIT_SAVEINFOMATION_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//编辑资料界面保存信息
- (NSURLSessionDataTask *)editPetSaveInfomation:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_EDITPETSAVEINFOMATION:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:EDIT_PETSAVEINFOMATION_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//编辑界面添加照片
- (NSURLSessionDataTask *)editViewAddPhotos:(NSDictionary *)dictionary data:(NSArray *)dataArr completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_EDIT_ADDPETIMAGES:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:EDIT_ADDPETIMAGE_URL parameters:startAppDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //取出数据
        for (UIImage *img in dataArr) {
            
                UIImage *image =img;
                NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:@"pet_images" fileName:@"test.jpg" mimeType:@"image/jpeg"];
           
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    return task;
}

//编辑资料界面删除照片
- (NSURLSessionDataTask *)editViewDeleteImage:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_DELETE_PETIMAGES:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:EDIT_DELETEPETIMAGES_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//编辑资料界面更改密码
- (NSURLSessionDataTask *)editChangeUserPassword:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_EDIT_CHANGEPWD:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:EDIT_CHANGEPASSWORD_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//创建群组
- (NSURLSessionDataTask *)newRoom:(NSDictionary *)dictionary data:(NSArray *)dataArr completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_KEY_CREATE_GROUP:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONTACT_CREATE_GROUP_URL parameters:startAppDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //取出数据
        for (NSDictionary *data in dataArr) {
            UIImage *image =[data objectForKey:@"image"];
            NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:REQUEST_KEY_CREATE_GROUP_IMAGE fileName:@"test.jpg" mimeType:@"image/jpeg"];
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    return task;
}


//联系人关注搜索
- (NSURLSessionDataTask *)focusSearch:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_CONTACTS_FOCUSSEARCH:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONTACTS_FOCUSSEARCH_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//联系人好友搜索
- (NSURLSessionDataTask *)friendsSearch:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_CONTACTS_FRIENDSSEARCH:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONTACTS_FRIENDSSEARCH_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

//联系人粉丝搜索
- (NSURLSessionDataTask *)fansSearch:(NSDictionary *)dictionary completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *startAppDict =@{REQUEST_CONTACTS_FANSSEARCH:[dictionary JSONString]};
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.requestSerializer.timeoutInterval =10.0f;
    
    NSURLSessionDataTask *task = [self POST:CONTACTS_FANSSEARCH_URL parameters:startAppDict success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    
    return task;
}

@end
