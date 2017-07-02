//
//  GVLPictureViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/2.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLPictureViewController.h"

@interface GVLPictureViewController ()

@end

@implementation GVLPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(GVLNavMaxY + GVLTitlesViewH, 0, GVLTabBarH, 0);
    self.view.backgroundColor = GVLRandomColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidAgainClick) name:GVLTabBarButtonDidAgainClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidAgainClick) name:GVLTitleButtonDidAgainClickNotification object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    GVLLog(@"刷新%@的view",self.class);
}
- (void)titleButtonDidAgainClick{
    [self tabBarButtonDidAgainClick];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
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
@end
