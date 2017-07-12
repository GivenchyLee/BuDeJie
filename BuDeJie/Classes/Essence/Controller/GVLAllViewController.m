//
//  GVLAllViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/2.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLAllViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "GVLNoteModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "GVLNoteCell.h"
@interface GVLAllViewController ()
@property(nonatomic, strong) AFHTTPSessionManager *manager;
//所有的帖子
@property(nonatomic, strong) NSMutableArray<GVLNoteModel *> *notesArrayM;
//当前加载所有帖子的最后一条的时间戳
@property(nonatomic, copy) NSString *currentTotalNotesMaxTime;

//上拉刷新控件
@property(nonatomic, weak) UIView *upDragRefreshView;
//上拉刷新控件里面的文字标签
@property(nonatomic, weak) UILabel *upDragRefreshTextLabel;
//上拉刷新状态
@property(nonatomic ,assign, getter=isUpDragingRefreshing) BOOL upDragingRefreshing;

//下拉刷新控件
@property(nonatomic, weak) UIView *downDragRefreshView;
//上来刷新控件里面的文字标签
@property(nonatomic, weak) UILabel *downDragRefreshTextLabel;
//下拉刷新状态
@property(nonatomic, assign, getter=isDownDragingRefreshing) BOOL downDragingRefreshing;
@end

@implementation GVLAllViewController

static NSString * const ID = @"GVLNoteCell";
#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(GVLNavMaxY + GVLTitlesViewH, 0, GVLTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.view.backgroundColor = GVLColor(206, 206, 206);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GVLNoteCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidAgainClick) name:GVLTabBarButtonDidAgainClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidAgainClick) name:GVLTitleButtonDidAgainClickNotification object:nil];
    [self setupRefresh];
}
- (void)setupRefresh{
    //headView用来显示广告
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.tableView.gvl_width, 30);
    UILabel *advertieseLabel = [[UILabel alloc] init];
    advertieseLabel.frame = headerView.frame;
    advertieseLabel.backgroundColor = [UIColor blackColor];
    advertieseLabel.text = @"广告";
    advertieseLabel.textAlignment = NSTextAlignmentCenter;
    advertieseLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:advertieseLabel];
    self.tableView.tableHeaderView = headerView;
    //下拉控件
    UIView *downDragRefreshView = [[UIView alloc] init];
    _downDragRefreshView = downDragRefreshView;
    downDragRefreshView.frame = CGRectMake(0, -60, self.tableView.gvl_width, 60);
    UILabel *downDragRefreshTextLabel = [[UILabel alloc] init];
    _downDragRefreshTextLabel = downDragRefreshTextLabel;
    downDragRefreshTextLabel.frame = CGRectMake(0, 0, self.tableView.gvl_width, 60);
    downDragRefreshTextLabel.backgroundColor = [UIColor redColor];
    downDragRefreshTextLabel.text = @"下拉加载更多";
    downDragRefreshTextLabel.textColor = [UIColor whiteColor];
    downDragRefreshTextLabel.textAlignment = NSTextAlignmentCenter;
    [downDragRefreshView addSubview:downDragRefreshTextLabel];
    [self.tableView addSubview:downDragRefreshView];
    
    [self beginDownDragingRefresh];
    
    //上拉刷新
    UIView *footerView = [[UIView alloc] init];
    _upDragRefreshView = footerView;
    footerView.frame = CGRectMake(0, 0, self.tableView.gvl_width, 35);
    //中间显示的文字标签
    UILabel *textLabel = [[UILabel alloc] init];
    _upDragRefreshTextLabel = textLabel;
    textLabel.frame = footerView.bounds;
    textLabel.backgroundColor = [UIColor grayColor];
    textLabel.text = @"上拉加载更多";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:textLabel];
    
    self.tableView.tableFooterView = footerView;
}
#pragma mark - 监听
- (void)tabBarButtonDidAgainClick{
    //判断是否是精华按钮连着第二次点击
    if (self.tableView.window == nil) {
        return;
    }
    //判断当前显示的view是不是allView
    if (self.tableView.scrollsToTop == NO) {
        return;
    }
    //刷新当前显示的页面
    [self beginDownDragingRefresh];
}
- (void)titleButtonDidAgainClick{
    [self tabBarButtonDidAgainClick];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.notesArrayM[indexPath.row].cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.tableFooterView.hidden = (self.notesArrayM.count == 0);
    return self.notesArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GVLNoteModel *currentRowNoteMode = self.notesArrayM[indexPath.row];
    GVLNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.noteMode = currentRowNoteMode;
    return cell;
}
#pragma mark - 处理网络请求加载数据
- (void)loadMoreData{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"10";
    parameters[@"maxtime"] = self.currentTotalNotesMaxTime;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        //更新currentTotalNotesMaxTime
        self.currentTotalNotesMaxTime = responseObject[@"info"][@"maxtime"];
        NSMutableArray *moreNotes = [GVLNoteModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.notesArrayM addObjectsFromArray:moreNotes];
        [self.tableView reloadData];
        [self endUpDragingRefresh];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试..."];
        }
        [self endUpDragingRefresh];
    }];
    /*
     *Error Domain=NSURLErrorDomain Code=-999 "cancelled" UserInfo={NSErrorFailingURLKey=http://api.budejie.com/api/api_open.php?a=list&c=data, NSLocalizedDescription=cancelled, NSErrorFailingURLStringKey=http://api.budejie.com/api/api_open.php?a=list&c=data}
     */
}
- (void)loadNewData{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //因为是下拉刷新，每一次请求到的都是最新的数据，而且是直接替换原来的数据的，所以不用传maxtime之类的东西
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"10";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        [responseObject writeToFile:@"/Users/givenchylee/Desktop/newData.plist" atomically:YES];
        self.currentTotalNotesMaxTime = responseObject[@"info"][@"maxtime"];
        //字典数组转模型数组
        self.notesArrayM = [GVLNoteModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //刷新表格
        [self.tableView reloadData];
        [self endDownDragingRefresh];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试..."];
        }
        [self endDownDragingRefresh];
    }];
}
#pragma mark - 开始刷新/结束刷新
- (void)beginUpDragingRefresh{
    if(self.isUpDragingRefreshing) return;
    self.upDragRefreshTextLabel.text = @"正在刷新数据";
    self.upDragRefreshTextLabel.backgroundColor = [UIColor orangeColor];
    self.upDragingRefreshing = YES;
    GVLLog(@"发送请求给服务器---加载更多数据");
    [self loadMoreData];

}
- (void)endUpDragingRefresh{
    //结束上拉刷新
    self.upDragingRefreshing = NO;
    self.upDragRefreshTextLabel.text = @"上拉加载更多";
    self.upDragRefreshTextLabel.backgroundColor = [UIColor grayColor];
}
- (void)beginDownDragingRefresh{
    if(self.isDownDragingRefreshing) return;
    self.downDragRefreshTextLabel.text = @"正在刷新数据...";
    self.downDragRefreshTextLabel.backgroundColor = [UIColor blueColor];
    self.downDragingRefreshing = YES;
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.downDragRefreshView.gvl_height;
        self.tableView.contentInset = inset;
        
        //当用户将内容滚到中间的时候，这个是偶在调用开始下拉刷新时候，这个时候应该让offsetY改变到用户能看见的那里
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, -self.tableView.contentInset.top);
    }];
    //请求网络数据
    GVLLog(@"发送请求给服务器---加载新的数据");
    [self loadNewData];
}
- (void)endDownDragingRefresh{
    self.downDragingRefreshing = NO;
    //减小内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.downDragRefreshView.gvl_height;
        self.tableView.contentInset = inset;
    }];
}
#pragma mark - 处理上下拉操作
- (void)dealDragingDown{
    if(self.isDownDragingRefreshing) return;
    CGFloat offsetY = - (self.tableView.contentInset.top + self.downDragRefreshView.gvl_height);
    if(self.tableView.contentOffset.y <= offsetY){
        self.downDragRefreshTextLabel.text = @"松开加载新的数据";
        self.downDragRefreshTextLabel.backgroundColor = [UIColor grayColor];
    }else{
        self.downDragRefreshTextLabel.text = @"下拉加载更多";
        self.downDragRefreshTextLabel.backgroundColor = [UIColor redColor];
    }
}
- (void)dealDragingUp{
    if(self.tableView.contentSize.height == 0) return;
    //数据量开始很小的时候，content.h + insetbottom - tableViewH 可能小于tableViewContenOffset.y(-99)，这个时候你向下移动一点点，结果就是tableViewContenOffset.y还是会大于offsetY.但是此时是不应该触发上拉刷新
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.gvl_height;
    if(self.tableView.contentOffset.y >= offsetY && self.tableView.contentOffset.y > -(self.tableView.contentInset.top)){
        //开始刷新
        [self beginUpDragingRefresh];
    }
}
#pragma mark - 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //上拉刷新
    [self dealDragingUp];
    //下来刷新
    [self dealDragingDown];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetY = - (self.tableView.contentInset.top + self.downDragRefreshView.gvl_height);
    if(self.tableView.contentOffset.y <= offsetY){
        //开始下拉刷新
        [self beginDownDragingRefresh];
    }
}
#pragma mark - 其它
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
