//
//  BaseHttpRequest.h
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/11/2.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSURLSessionTask BaseSessionTask;

@interface BaseHttpRequest : NSObject

+ (instancetype)shareManager;

+ (BaseSessionTask *)post:(NSString *)url
                parameter:(NSDictionary *)parameter
             HttpProgress:(void(^)(NSProgress *progress))progress
                  success:(void(^)(id responseObject,BOOL error))success
                  failure:(void(^)(NSError *error))failure;


@end
