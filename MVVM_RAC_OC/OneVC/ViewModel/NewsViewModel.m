//
//  NewsViewModel.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/11/2.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "NewsViewModel.h"
#import "NewsModel.h"

@interface NewsViewModel ()
@property (nonatomic, assign) NSInteger newPageNum;

@end

@implementation NewsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@synthesize updateNewsSignal = _updateNewsSignal;
- (RACSignal *)updateNewsSignal{
    if (!_updateNewsSignal) {
        @synchronized(self){
            if (!_updateNewsSignal) {
                @weakify(self)
                _updateNewsSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                    @strongify(self)
                    [self requestNewSubscribeWithPage:self.newPageNum completion:^{
                        
                        [subscriber sendNext:nil];

                       

                    }];
                    return nil;

                }];
                self.newPageNum = 1;
            }
        }
    }
    
    return _updateNewsSignal;
}

- (void)requestNewSubscribeWithPage:(NSInteger)page completion:(void(^)(void))completion{
    NSMutableDictionary * parames = [NSMutableDictionary dictionary];
    parames[@"page"] = @(_newPageNum);
//    parames[@"size"]  = @(10);
    [BaseHttpRequest post:APIURL parameter:parames HttpProgress:^(NSProgress *progress) {
        
    } success:^(id responseObject, BOOL error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WSProgressHUD dismiss];

        });
        if (error) {
            NSLog(@"responseObject=%@",responseObject);
            if (self.newPageNum == 1) {
                self.newsList = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"newbooks"]];
                
            } else {
                [self.newsList addObjectsFromArray:[NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"newbooks"]]];
            }
            completion();
        }
    } failure:^(NSError *error) {
        NSLog(@"error :%@",error.localizedDescription);

    }];
}


- (NSMutableArray *)newsList{
    if (!_newsList) {
        _newsList = [[NSMutableArray alloc] init];
    }
    return _newsList;
}

- (NSMutableArray *)advertis
{
    if (!_advertis) {
        _advertis = [[NSMutableArray alloc] init];
    }
    return _advertis;
}

@end
