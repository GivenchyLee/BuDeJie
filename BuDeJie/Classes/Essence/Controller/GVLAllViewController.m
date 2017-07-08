//
//  GVLAllViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/2.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLAllViewController.h"

@interface GVLAllViewController ()
@property(nonatomic, assign) NSInteger dataCount;
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
@property(nonatomic, assign, getter=isDownDragingRefreshing) BOOL downDragingRefreshing;
@end

@implementation GVLAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(GVLNavMaxY + GVLTitlesViewH, 0, GVLTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.view.backgroundColor = GVLRandomColor;
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.tableFooterView.hidden = (self.dataCount == 0);
    return self.dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * const ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@---->%ld", NSStringFromClass([self class]), indexPath.row];
    
    return cell;
}
#pragma mark - 代理方法
- (void)loadMoreData{
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //服务器返回数据
        self.dataCount += 5;
        [self.tableView reloadData];
        [self endUpDragingRefresh];
        
    });
}
- (void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //结束刷新
        //更新数据
        self.dataCount = 20;
        [self.tableView reloadData];
        [self endDownDragingRefresh];
    });
}
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
#pragma mark - 其它
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
