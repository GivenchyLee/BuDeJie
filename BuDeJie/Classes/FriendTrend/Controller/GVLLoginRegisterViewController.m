//
//  GVLLoginRegisterViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/22.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLLoginRegisterViewController.h"
#import "GVLRegisterLoginView.h"
#import "GVLFastLoginView.h"
@interface GVLLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;

@end

@implementation GVLLoginRegisterViewController
- (IBAction)closeViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)pressRegisterButton:(UIButton *)button {
    button.selected = !button.selected;
    _leadingCons.constant = _leadingCons.constant == 0? -self.middleView.gvl_width*0.5:0;
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //加载登录界面
    [self.middleView addSubview:[GVLRegisterLoginView loginView]];
    //加载注册界面
    [self.middleView addSubview:[GVLRegisterLoginView registerView]];
    //加载快速登录界面
    [self.bottomView addSubview:[GVLFastLoginView fastLoginView]];
}
//控制器里面修改View的布局是viewDidLayoutSubviews这个方法
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    GVLRegisterLoginView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.gvl_width*0.5, self.middleView.gvl_width);
    GVLRegisterLoginView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.gvl_width*0.5, 0, self.middleView.gvl_width*0.5, self.middleView.gvl_width);
    
    GVLFastLoginView *fastLoginView = self.bottomView.subviews[0];
    fastLoginView.frame = self.bottomView.bounds;
    
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
