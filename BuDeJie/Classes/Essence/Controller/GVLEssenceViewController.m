//
//  GVLEssenceViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/13.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLEssenceViewController.h"

@interface GVLEssenceViewController ()

@end

@implementation GVLEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GVLRandomColor;
    //设置导航条
    [self setupNav];
}
- (void)setupNav{
    //设置导航条左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"MainTagSubIcon" highlightImageName:@"MainTagSubIconClick" target:self action:@selector(leftClick)];
    //设置标题view
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //设置导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"nav_coin_icon" highlightImageName:@"nav_coin_icon_click" target:nil action:nil];
    
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
