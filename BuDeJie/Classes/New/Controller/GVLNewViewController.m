//
//  GVLNewViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/13.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLNewViewController.h"
#import "GVLSubTagViewController.h"
@interface GVLNewViewController ()

@end

@implementation GVLNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GVLRandomColor;
    //设置导航条
    [self setupNav];
}
- (void)setupNav{
    //设置导航条左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"MainTagSubIcon" highlightImageName:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    //设置标题view
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

- (void)tagClick{
    [self.navigationController pushViewController:[[GVLSubTagViewController alloc] init] animated:YES];
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
