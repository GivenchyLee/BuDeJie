//
//  GVLEssenceViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/13.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLEssenceViewController.h"
#import "GVLTitleButton.h"
#import "GVLAllViewController.h"
#import "GVLVideoViewController.h"
#import "GVLVoiceViewController.h"
#import "GVLPictureViewController.h"
#import "GVLWordViewController.h"

#define kTitleButtonCount 5
@interface GVLEssenceViewController () <UIScrollViewDelegate>
@property(nonatomic, weak) UIView *titlesView;
@property(nonatomic, weak) GVLTitleButton *previousSelectedButton;
@property(nonatomic, weak) UIView *underLine;
@property(nonatomic, weak) UIScrollView *scrollView;
@end

@implementation GVLEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setupNav];
    
    //添加5个tableviewController,要写在setupScrollView前面，因为我们要给scrollView上面添加tableviewController,所以应该先有tableviewController
    [self setupChildTableviewController];
    
    //添加ScrollView
    [self setupScrollView];
    
    //添加titlesView
    [self setupTitlesView];
    
    UIView *childViewControllerView = self.childViewControllers[0].view;
    childViewControllerView.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childViewControllerView];
}
- (void)setupNav{
    //设置导航条左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"MainTagSubIcon" highlightImageName:@"MainTagSubIconClick" target:self action:@selector(leftClick)];
    //设置标题view
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //设置导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"nav_coin_icon" highlightImageName:@"nav_coin_icon_click" target:nil action:nil];
    
}
- (void)setupChildTableviewController{
    [self addChildViewController:[[GVLAllViewController alloc] init]];
    [self addChildViewController:[[GVLVideoViewController alloc] init]];
    [self addChildViewController:[[GVLVoiceViewController alloc] init]];
    [self addChildViewController:[[GVLPictureViewController alloc] init]];
    [self addChildViewController:[[GVLWordViewController alloc] init]];
}
- (void)setupScrollView{
    //UIViewController有一个属性，automaticallyAdjustsScrollViewInset 默认值是YES，所以当Scrollview处于导航控制器的下面时候， 这个属性会使scollview自动增加64的内边距，让内容向下偏移64，不至于被导航条遮挡住
    //这里想让scrollView占据整个屏幕
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.gvl_width, self.view.gvl_height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = GVLRandomColor;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.gvl_width, 0);
    
}
- (void)setupTitlesView{
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, GVLNavMaxY, self.view.gvl_width, GVLTitlesViewH)];
    _titlesView = titlesView;
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:titlesView];
    
    //在titlesView上面添加5个按钮
    [self addButtons2TitlesView];
    
    //在titlesView上面添加下划线
    [self addUnderLine2TitlesView];
    
}
- (void)addUnderLine2TitlesView{
    UIView *underLine = [[UIView alloc] init];
    _underLine = underLine;
    //拿到标题按钮，设置下划线为按钮选中时候的颜色
    GVLTitleButton *titleButton = [[self.titlesView subviews] firstObject];
    underLine.backgroundColor = [titleButton titleColorForState:UIControlStateSelected];
    //设置按钮的frame
    underLine.gvl_x = 0;
    underLine.gvl_height = 2;
    underLine.gvl_y = self.titlesView.gvl_height - underLine.gvl_height;
    [self.titlesView addSubview:underLine];
    //第一次进来时候让第一个标题按钮选中
    self.previousSelectedButton.selected = NO;
    titleButton.selected = YES;
    self.previousSelectedButton = titleButton;
    [titleButton.titleLabel sizeToFit];
    self.underLine.gvl_width = titleButton.titleLabel.gvl_width;
    self.underLine.gvl_centerX = titleButton.gvl_centerX;
}
- (void)addButtons2TitlesView{
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    CGFloat titleButtonH = self.titlesView.gvl_height;
    CGFloat titleButtonW = self.view.gvl_width/kTitleButtonCount;
    for (NSUInteger i = 0; i < kTitleButtonCount; i++) {
        GVLTitleButton *titleButton = [[GVLTitleButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        [self.titlesView addSubview:titleButton];
    }
}
#pragma mark -监听点击
- (void)titleButtonClick:(GVLTitleButton *)button{
    //判断是否重复点击了同一个标题按钮
    if (self.previousSelectedButton == button) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GVLTitleButtonDidAgainClickNotification object:nil];
    }
    [self changeButtonStyle:button];
}
- (void)changeButtonStyle:(GVLTitleButton *)button{
    self.previousSelectedButton.selected = NO;
    button.selected = YES;
    self.previousSelectedButton = button;
    
    //调整下划线的位置
    [UIView animateWithDuration:0.1 animations:^{
        self.underLine.gvl_width = button.titleLabel.gvl_width;
        self.underLine.gvl_centerX = button.gvl_centerX;
        
        //点击按钮的时候调整下面scrollView的偏移
        CGFloat contentOffsetX = self.scrollView.gvl_width * button.tag;
        self.scrollView.contentOffset = CGPointMake(contentOffsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        //加载按钮对应的控制器view
        UIView *childViewControllerView = self.childViewControllers[button.tag].view;
        childViewControllerView.frame = self.scrollView.bounds;
        [self.scrollView addSubview:childViewControllerView];
    }];
    
    //设置当前显示的tableView的scrollToTop为YES其余的tableView的scrollToTop设置为NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childViewController = self.childViewControllers[i];
        if(!childViewController.viewLoaded) continue;
        //这一句只是告诉编译器，我认为childViewController.view这个是个scrollView
        UIScrollView *scrollView = (UIScrollView *)childViewController.view;
        //这里的判断才是真的看看到底是不是真的是scrollView
        if(![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        scrollView.scrollsToTop = (i == button.tag);
    }
}
- (void)leftClick{
    GVLLog(@"%s", __func__);
}
#pragma mark -UIScrollViewDelegate协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger buttonIndex = self.scrollView.contentOffset.x / self.scrollView.gvl_width;
    GVLTitleButton *titleButton = self.titlesView.subviews[buttonIndex];
    [self changeButtonStyle:titleButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
