//
//  GVLEssenceViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/13.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLEssenceViewController.h"
#import "GVLTitleButton.h"
#define kTitleButtonCount 5
@interface GVLEssenceViewController ()
@property(nonatomic, strong) UIView *titlesView;
@property(nonatomic, strong) GVLTitleButton *previousSelectedButton;
@end

@implementation GVLEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setupNav];
    //添加ScrollView
    [self setupScrollView];
    //添加titlesView
    [self setupTitlesView];
}
- (void)setupNav{
    //设置导航条左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"MainTagSubIcon" highlightImageName:@"MainTagSubIconClick" target:self action:@selector(leftClick)];
    //设置标题view
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //设置导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"nav_coin_icon" highlightImageName:@"nav_coin_icon_click" target:nil action:nil];
    
}
- (void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.gvl_width, self.view.gvl_height)];
    scrollView.backgroundColor = GVLRandomColor;
    [self.view addSubview:scrollView];
}
- (void)setupTitlesView{
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.gvl_width, 35)];
    _titlesView = titlesView;
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    //在titlesView上面添加5个按钮
    [self addButtons2TitlesView];
    [self.view addSubview:titlesView];
}
- (void)addButtons2TitlesView{
    NSArray *titles = @[@"全部", @"视频", @"图片", @"段子", @"声音"];
    CGFloat titleButtonH = self.titlesView.gvl_height;
    CGFloat titleButtonW = self.view.gvl_width/kTitleButtonCount;
    for (NSUInteger i = 0; i < kTitleButtonCount; i++) {
        GVLTitleButton *titleButton = [[GVLTitleButton alloc] init];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.titlesView addSubview:titleButton];
    }
}
#pragma mark -响应
- (void)titleButtonClick:(GVLTitleButton *)button{
    self.previousSelectedButton.selected = !self.previousSelectedButton.selected;
    button.selected = YES;
    self.previousSelectedButton = button;
}
- (void)leftClick{
    GVLLog(@"%s", __func__);
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
