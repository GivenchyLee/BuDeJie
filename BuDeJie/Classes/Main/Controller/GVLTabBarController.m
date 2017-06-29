//
//  GVLTabBarController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/14.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLTabBarController.h"
#import "GVLEssenceViewController.h"
#import "GVLFriendTrendViewController.h"
#import "GVLMeViewController.h"
#import "GVLNewViewController.h"
#import "GVLPublishViewController.h"
#import "UIImage+Render.h"
#import "GVLTabBar.h"
#import "GVLNavigationController.h"
@interface GVLTabBarController ()

@end

@implementation GVLTabBarController
+ (void)load{
    //拿到所有的tabBarItem
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *selectedDict = [NSMutableDictionary dictionary];
    selectedDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [tabBarItem setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
    
    //设置字体的大小，设置字体的大小只能在normal状态下
    NSMutableDictionary *normalDict = [NSMutableDictionary dictionary];
    normalDict[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];
    [tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //将系统的tabBar换成我们自定义的tabBar
    [self setupTabBar];
    //添加控制器
    [self setupChildController];


}
- (void)setupTabBar{
    GVLTabBar *tabBar = [[GVLTabBar alloc] init];
    //由于系统的tabBar属性是readOnly的，所以只能通过kvc的方式来赋值
    [self setValue:tabBar forKeyPath:@"tabBar"];
}
- (void)setupChildController{
    //添加完成之后出现了的问题
    //1.选中的时候的颜色不对->可能是系统给我渲染了,系统默认是用UIImageRenderingModeAutomatic来渲染的
    //     通过修改渲染模式调整好了图片的问题，文字的问题还是没有修改好
    // 1.1 文字的问题还是没有修改好
    //      想到用 appearance，但是tabBarItem有多个文字需要设置，能不能再某个地方一次性设置呢，这个时候我们想到了在load方法中进行设置
    //2.中间的发布按钮显示有问题
    //     取消中间发布按钮的渲染模式之后，可以正常显示了，但是位置不对
    // 2.1 位置不对，我们查看有咩有可以修改位置的属性，找到了imageInsets属性,下来是下来了，但是图片的形状完全变形了，经过调整我们可以将位置摆放到我们想要的位置，但是点击一下，当我们松开鼠标，图片还是显示的是selected状态，系统的tabBarItem只提供了两种状态，没有高亮状态。这是后是因为状态的问题无法解决，所以我们决定放弃这种方法。
    // 2.2 由于2.1达不到我们的需求，这就需要自定义TabBar，这样子才能拿到里面的tabBarItem设置相应的状态。
    GVLEssenceViewController *essenceVc = [[GVLEssenceViewController alloc] init];
    [self addChildController:essenceVc title:@"精华" imageName:@"tabBar_essence_icon" selectedImageName:@"tabBar_essence_click_icon"];
    
    GVLNewViewController *newVc = [[GVLNewViewController alloc] init];
    [self addChildController:newVc title:@"新帖" imageName:@"tabBar_new_icon" selectedImageName:@"tabBar_new_click_icon"];
    
//    GVLPublishViewController *publishVc = [[GVLPublishViewController alloc] init];
//    publishVc.tabBarItem.image = [UIImage imageWithoutRendering:@"tabBar_publish_icon"];
//    publishVc.tabBarItem.selectedImage = [UIImage imageWithoutRendering:@"tabBar_publish_click_icon"];
//    publishVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);//上左下右，逆时针
//    [self addChildViewController:publishVc];
    
    GVLFriendTrendViewController *friendTrendVC = [[GVLFriendTrendViewController alloc] init];
    [self addChildController:friendTrendVC title:@"关注" imageName:@"tabBar_friendTrends_icon" selectedImageName:@"tabBar_friendTrends_click_icon"];
    
    //GVLMeViewController *meVc = [[GVLMeViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([GVLMeViewController class]) bundle:nil];
    GVLMeViewController *meVc = [storyboard instantiateInitialViewController];
    [self addChildController:meVc title:@"我" imageName:@"tabBar_me_icon" selectedImageName:@"tabBar_me_click_icon"];
}
- (void)addChildController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)normalName selectedImageName:(NSString *)selectedName{
    
    GVLNavigationController *nav = [[GVLNavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageWithoutRendering:normalName];
    nav.tabBarItem.selectedImage = [UIImage imageWithoutRendering:selectedName];
    [self addChildViewController:nav];
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
