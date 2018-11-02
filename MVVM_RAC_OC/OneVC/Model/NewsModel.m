//
//  NewsModel.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/11/2.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"nid":@"id"};
}

@end
