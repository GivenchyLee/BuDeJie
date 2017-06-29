//
//  GVLAdvertiseViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/16.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLAdvertiseViewController.h"
#import "GVLTabBarController.h"
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import "GVLAdvertiseModel.h"
#define GVLAdvertiseCode2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"
@interface GVLAdvertiseViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *advertisePlaceHolderView;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@property (strong, nonatomic) GVLAdvertiseModel *advertiseModel;
//存储模型中请求到的广告背景图片
@property (weak, nonatomic) UIImageView *advertiseView;
//倒计时timer
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation GVLAdvertiseViewController
- (IBAction)jumpButtonClick:(id)sender {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[GVLTabBarController alloc] init];
    [_timer invalidate];
}

#pragma mark -懒加载
- (UIImageView *)advertiseView{
    if (_advertiseView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //创建一个点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [imageView addGestureRecognizer:tapGesture];
        //由于imageView一般是不能相应点击事件的，所以这里设置一下允许交互
        imageView.userInteractionEnabled = YES;
        //由于@property里面用的是weak，这里必须添加到父控件上面
        [self.advertisePlaceHolderView addSubview:imageView];
        _advertiseView = imageView;
    }
    return _advertiseView;
}
- (void)tapClick{
    //跳转到广告界面,因为广告界面是一个网页，所以我们用浏览器打开
    UIApplication *budejieAPP = [UIApplication sharedApplication];
    NSURL *targetUrl = [NSURL URLWithString:_advertiseModel.ori_curl];
    if ([budejieAPP canOpenURL:targetUrl]) {
        [budejieAPP openURL:targetUrl];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置启动图片
    [self setupLaunchImage];
    //请求广告数据
    [self loadAdvertiseData];
    //添加倒计时timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
}
- (void)timerChange{
    static int count = 3;
    if (count == 0) {
        //销毁定时器，添加主窗口
        [self jumpButtonClick:nil];
    }
    count--;
    NSString *jumpButtonText = [NSString stringWithFormat:@"跳过(%d)",count];
    [_jumpButton setTitle:jumpButtonText forState:UIControlStateNormal];
}
- (void)setupLaunchImage{
    //6p/7p:LaunchImage-800-Portrait-736h@3x
    //6/7:LaunchImage-800-667h@2x
    //5:LaunchImage-568h@2x
    //4:LaunchImage@2x

    if (iphone7pAndiphone6p) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x.png"];
    }else if (iphone7Andiphone6){
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h@2x.png"];
    }else if (iphone5){
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h@2x.png"];
    }else{
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage@2x.png"];
    }
}
- (void)loadAdvertiseData{
    //请求网络数据，需要用到afn
    //1.创建一个回话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //2.发送请求
    //2.1创建一个参数字典
    NSMutableDictionary *parametersDictM = [NSMutableDictionary dictionary];
    parametersDictM[@"code2"] = GVLAdvertiseCode2;
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parametersDictM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        //请求数据->解析数据（设计模型、字典转模型）->展示数据
//        [responseObject writeToFile:@"/Users/givenchylee/Desktop/iOSApplications/advertise.plist" atomically:YES];
        //拿到数据字典
        NSDictionary *advertiseDict = [responseObject[@"ad"] lastObject];
        //字典转模型 需要用到第三方库MJExtension
        _advertiseModel = [GVLAdvertiseModel mj_objectWithKeyValues:advertiseDict];
        //展示这个图片 //由于懒加载的时候没有设置frame，这里数据设置好了要向显示，必须设置frame
        //按比例缩放，显示尺寸/模型里面图片的尺寸
        CGFloat advertiseViewH = (GVLScreemW / _advertiseModel.w) * _advertiseModel.h;
        self.advertiseView.frame = CGRectMake(0, 0, GVLScreemW, advertiseViewH);
        [self.advertiseView sd_setImageWithURL:[NSURL URLWithString:_advertiseModel.w_picurl]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GVLLog(@"%@",error);
    }];
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
