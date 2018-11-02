//
//  EnterController.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/11/1.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "EnterController.h"
#import "NewsViewModel.h"
#import "NewsModel.h"

//#define kIDCell @"IDCell"

@interface EnterController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTabView;

@property(nonatomic,strong) NewsViewModel *viewModel;

@end

@implementation EnterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = @"RAC_MVVM";
//    if (@available(iOS 11.0, *)) {
//        [self.navigationController.navigationBar setPrefersLargeTitles:YES];
//    } 
//    self.extendedLayoutIncludesOpaqueBars = YES;

//    [self.mainTabView reloadData];
//    self.mainTabView.alpha = 1.0;
    [self.mainTabView.mj_header beginRefreshing];


//    if (@available(iOS 11.0,*)) {
//        self.mainTabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.mainTabView.estimatedRowHeight = 0;
//        self.mainTabView.estimatedSectionHeaderHeight = 0;
//        self.mainTabView.estimatedSectionFooterHeight = 0;
//    }else{
//            self.automaticallyAdjustsScrollViewInsets = NO;
//
//    }
    
//    @weakify(self)
//    [self.viewModel.updateNewsSignal subscribeNext:^(NSArray* ) {
//        <#code#>
//    }];

}

- (void)downData {
    @weakify(self);
    [self.viewModel.updateNewsSignal subscribeNext:^(id x) {
        @strongify(self);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mainTabView.mj_header endRefreshing];
            [self.mainTabView.mj_footer endRefreshing];
            [self.mainTabView reloadData];
        });
        
    }];
}

-(NewsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[NewsViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)mainTabView{
    if (_mainTabView == nil) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.rowHeight = 120;
        table.estimatedRowHeight = 120;
//        table.backgroundColor = [UIColor cyanColor];
//        table.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);

        [self.view addSubview:_mainTabView=table];
        
        self.mainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downData)];
        
        
        
        
//        [_mainTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:kIDCell];
    }
    return _mainTabView;
}

#pragma mark - UITablewDelegateWay
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.newsList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCell = @"IDCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
        cell.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"%ld",indexPath.row);

    }
    
    NewsModel *model = (NewsModel *)self.viewModel.newsList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.publisher];

    
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
//    NSLog(@"%ld",indexPath.row);
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
