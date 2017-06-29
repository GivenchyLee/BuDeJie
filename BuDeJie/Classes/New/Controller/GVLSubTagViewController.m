//
//  GVLSubTagViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/21.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLSubTagViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "GVLSubTagModel.h"
#import "GVLSubTagCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const ID = @"cell";
@interface GVLSubTagViewController ()
@property(copy, nonatomic) NSArray *subTagModelArray;
@property(weak, nonatomic) AFHTTPSessionManager *mgr;
@end

@implementation GVLSubTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self loadData];
    //设置标题
    self.title = @"推荐标签";
    //注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GVLSubTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
    [self setingSeparatorLine];
    
    //加载指示遮罩
    [SVProgressHUD showWithStatus:@"正在加载......"];
    
}
- (void)setingSeparatorLine{
    //取消系统的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //将tableView的背景色设置成分割线的颜色
    self.tableView.backgroundColor = GVLColor(220, 220, 221);
}
- (void)loadData{
    //展示数据
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    _mgr = mgr;
    NSMutableDictionary *parametersDictM = [NSMutableDictionary dictionary];
    parametersDictM[@"a"] = @"tag_recommend";
    parametersDictM[@"action"] = @"sub";
    parametersDictM[@"c"] = @"topic";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parametersDictM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
            //请求成功取消遮罩
            [SVProgressHUD dismiss];
            //字典转模型
            _subTagModelArray = [GVLSubTagModel mj_objectArrayWithKeyValuesArray:responseObject];
            //刷新表格
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
        }];
    });
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTagModelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    GVLSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    GVLSubTagModel *subTagModel = self.subTagModelArray[indexPath.row];
    cell.subTagModel = subTagModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消遮罩
    [SVProgressHUD dismiss];
    //取消任务
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
