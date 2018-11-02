//
//  NewsViewModel.h
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/11/2.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsViewModel : NSObject

@property (nonatomic ,strong)   NSMutableArray * newsList;
@property (nonatomic ,strong)   NSMutableArray * advertis;

@property (nonatomic ,strong)   RACSubject     * cellClickSubJect;
@property (nonatomic ,readonly) RACSignal      * updateNewsSignal;




@end
