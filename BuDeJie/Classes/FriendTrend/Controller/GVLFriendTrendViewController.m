//
//  GVLFriendTrendViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/13.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLFriendTrendViewController.h"
#import "GVLLoginRegisterViewController.h"
#import "UITextField+GVLPlaceholderColor.h"
@interface GVLFriendTrendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *demoTextField;

@end

@implementation GVLFriendTrendViewController
- (IBAction)logInRegisterClick:(id)sender {
    [self presentViewController:[[GVLLoginRegisterViewController alloc] init] animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    
    _demoTextField.placeholderColor = [UIColor redColor];
    _demoTextField.placeholder = @"nidaye";
}
- (void)setupNav{
    //设置导航条左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"friendsRecommentIcon" highlightImageName:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecomment)];
    //设置标题
    self.navigationItem.title = @"我的关注";
    
}

- (void)friendsRecomment{
    
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
