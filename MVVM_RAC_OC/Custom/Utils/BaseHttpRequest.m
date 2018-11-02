//
//  BaseHttpRequest.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/11/2.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "BaseHttpRequest.h"
#import <AFNetworkActivityIndicatorManager.h>
//#import <WSProgressHUD.h>

static BaseHttpRequest *baseSessionManager= nil;


@implementation BaseHttpRequest

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseSessionManager = [[BaseHttpRequest alloc] init];
        
    });
    return baseSessionManager;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseSessionManager = [super allocWithZone:zone];
    });
    return baseSessionManager;
}

+ (AFHTTPSessionManager *)createAFHttpSessionManager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 15;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        manager.responseSerializer = response;
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        
    });
    return manager;
}

+(BaseSessionTask *)post:(NSString *)url parameter:(NSDictionary *)parameter HttpProgress:(void (^)(NSProgress *))progress success:(void (^)(id, BOOL))success failure:(void (^)(NSError *))failure{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    
    AFHTTPSessionManager *manager = [self createAFHttpSessionManager];
    return [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

//        NSLog(@"responseObject=%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"has_error"]];
        if ([code isEqualToString:@"0"]) {
            success ? success(responseObject,YES) : nil;
        }else{
            success ? success(responseObject,NO) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [WSProgressHUD dismiss];
        
    }];
    
}

@end
