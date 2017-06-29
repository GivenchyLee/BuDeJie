//
//  GVLMeViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/13.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLMeViewController.h"
#import "GVLSettingViewController.h"
#import "GVLSquareCell.h"
#import "GVLSquareCellModel.h"
#import "GVLWebViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

#define CollectionViewColumns 4
#define Margin 1
#define CellWH (GVLScreemW - (CollectionViewColumns-1)*Margin)/CollectionViewColumns
static NSString * const ID = @"cell";
@interface GVLMeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, copy) NSMutableArray *squareCellModeArrayM;
@property(nonatomic, weak) UICollectionView *collectionView;
@end

@implementation GVLMeViewController
// 通过打印这两个值，最后得出的结论是将cotentInset向上移动25,达到各个section的间距都是10；
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    GVLLog(@"%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    GVLLog(@"%@", NSStringFromCGRect([tableView cellForRowAtIndexPath:indexPath].frame));
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    //设置tableview的footerView
    [self setupFooterView];
    [self loadingData];
    
    //处理sb中cell的间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
}
- (void)loadingData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parametersDictM = [NSMutableDictionary dictionary];
    parametersDictM[@"a"] = @"square";
    parametersDictM[@"c"] = @"topic";
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parametersDictM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
//        GVLLog(@"%@",responseObject) responseObject[@"square_list"]字典数组，所以要进行字典转模型
        _squareCellModeArrayM = [GVLSquareCellModel mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        //成功拿到数据之后，刷新表格 也就是调用dataSource的代理方法
        //由于之前创建collectionView的时候是随便给了个高度，那么在数据请求成功的时候，这时候，我们就能计算出真实的高度了，所以在这里更新collectionView的高度
        self.collectionView.gvl_height = ((self.squareCellModeArrayM.count - 1)/CollectionViewColumns + 1) * CellWH;
        self.tableView.tableFooterView = self.collectionView;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)setupFooterView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //通过flow来设置collectionViewCell的尺寸
    flowLayout.itemSize = CGSizeMake(CellWH, CellWH);
    flowLayout.minimumLineSpacing = Margin;
    flowLayout.minimumInteritemSpacing = Margin;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:flowLayout];
    collectionView.scrollEnabled = NO;
    //注册自定义cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GVLSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = self.tableView.backgroundColor;
    _collectionView = collectionView;
    
    
    self.tableView.tableFooterView = collectionView;
    
}
- (void)setupNav{
    //设置标题
    self.navigationItem.title = @"我的";
    //设置导航条右侧按钮
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"nav_coin_icon" highlightImageName:@"nav_coin_icon_click" target:nil action:nil];
    UIBarButtonItem *settingRightButton = [UIBarButtonItem barButtonItemWithImageName:@"mine-setting-icon" highlightImageName:@"mine-setting-icon-click" target:self action:@selector(setting)];
    UIBarButtonItem *moonRightButton = [UIBarButtonItem barButtonItemWithImageName:@"mine-moon-icon" selectedImageName:@"mine-sun-icon-click" target:self action:@selector(moonModel:)];
    NSArray *rightBarButtons = [NSArray arrayWithObjects:settingRightButton, moonRightButton, nil];
    self.navigationItem.rightBarButtonItems = rightBarButtons;
    
    //修改导航栏上面字体的大小
    //功能是实现了，如果有标题，每一个都要这样子设置，而且还是在修改导航控制器里面的navigationBar的属性，所以我们决定
    //自定义navigationController将这些代码直接在自定义的控制器中实现。
}
//设置按钮点击事件
- (void)setting{
    GVLSettingViewController *settingVc = [[GVLSettingViewController alloc] init];
    settingVc.view.backgroundColor = GVLRandomColor;
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
}
//夜间模式选中
- (void)moonModel:(UIButton *)moonButton{
    //因为按钮选中必须要手动实现，所以在这个方法里面将状态设置成selected
    moonButton.selected = !moonButton.selected;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GVLSquareCellModel *currentSquareCellMode = self.squareCellModeArrayM[indexPath.item];
    if (![currentSquareCellMode.url containsString:@"http"]) return;
    
    GVLWebViewController *webVc = [[GVLWebViewController alloc] init];
    webVc.url = [NSURL URLWithString:currentSquareCellMode.url];
    [self.navigationController pushViewController:webVc animated:YES];
    
}
#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _squareCellModeArrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GVLSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.cellMode = self.squareCellModeArrayM[indexPath.item];
    return cell;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
