//
//  GVLNavigationController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/15.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLNavigationController.h"

@interface GVLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation GVLNavigationController
+ (void)load{
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navigationBar setTitleTextAttributes:dict];
    
    //设置导航栏的背景图片
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //创建返回按钮
    if (self.childViewControllers.count > 0) {
        //这里如果重写返回按钮，那么控制器就会失去滑动返回的效果--->滑动返回效果是手势完成的，那么可能是我们这样子导致了系统将手势清空了，为此我们在if条件语句里面打印一下手势。
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backButtonItemWithImageName:@"navigationButtonReturn" highlightImageName:@"navigationButtonReturnClick" target:self action:@selector(back)];
        //GVLLog(@"%@", self.interactivePopGestureRecognizer);
        //结果打印如下，并没有清空。--->这个时候如果手势还在，那么可能的原因就是 代理可能会有判断，如果我们自定义了返回按钮，那么就会手势就会失效，虽然它还存在--->为此我们将手势的代理置空，看一下效果。
        /*<UIScreenEdgePanGestureRecognizer: 0x7ff060419980; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7ff060417dc0>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7ff060418f70>)>>
         */
    }
    //这句代码才是真正的跳转
    [super pushViewController:viewController animated:animated];
}
- (void)back{
    [self popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //在这里将手势的代理置空，果然在修改了返回按钮的时候可以滑动返回了，但是当我们在根控制器的时候还是会触发这个手势，然后造成滑动返回一个透明的遮罩，造成我们整个程序无法响应用户交互，造成假死 ---> 为了避免这种事情，我们必须拿到代理，自己控制让他不要在跟控制器也接受这个手势。为了能拿到这个代理做事情，我们将代理设置成自己。
//    self.interactivePopGestureRecognizer.delegate = self;
    
    //优化：为什么我们的手势不能全屏滑动呢，我们看到了刚才打印出来的系统滑动手势的信息的类名字为UIScreenEdgePanGestureRecognizer，如其名子所示
    //它是一个ScreenEdge不是一个全屏手势，我们点进去这个类看一下UIScreenEdgePanGestureRecognizer : UIPanGestureRecognizer，发现这个类是
    //全屏手势UIPanGestureRecognizer的一个子类，而且它还有一个属性UIRectEdge edges，而这个属性可设置的值有一下这几个
    /*
     UIRectEdgeNone   = 0,
     UIRectEdgeTop    = 1 << 0,
     UIRectEdgeLeft   = 1 << 1,
     UIRectEdgeBottom = 1 << 2,
     UIRectEdgeRight  = 1 << 3,
     UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
     */
    //所以我们决定试试这几个值能不能搞定
//    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = self.interactivePopGestureRecognizer;
//    edgePanGestureRecognizer.edges = UIRectEdgeNone;
    //试过了之后很遗憾，不能解决问题---> 我们自己创建一个全屏手势，添加到控制器的View上面，创建手势的时候会添加一个target和action。
    //我们想到了系统的呢个滑动也有一个target和action，刚好我们可以利用系统的这个从而避免了我们来实现这个滑动效果，由于刚才打印了self.interactivePopGestureRecognizer.delegate的类型和系统手势里面的target是一个类型，所以我们这里直接传这个代理也是可行的
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    self.interactivePopGestureRecognizer.enabled = NO;
    
}
#pragma mark -手势代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.childViewControllers.count > 1;
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
