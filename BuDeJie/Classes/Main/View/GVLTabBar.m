//
//  GVLTabBar.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/14.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLTabBar.h"
#import "UIView+Frame.h"
@interface GVLTabBar()
@property(nonatomic, weak) UIButton *publishButton;
@property(nonatomic, strong) UIControl *previousClickedTabBarButton;
@end

@implementation GVLTabBar
- (UIButton *)publishButton{
    if (_publishButton == nil) {
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton sizeToFit];
        [self addSubview:publishButton];
        _publishButton = publishButton;
    }
    return _publishButton;
}
//这个方法可能会调用多次，所以发布按钮只需要创建一次，所以我们采用属性懒加载的方式
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat buttonW = self.bounds.size.width/(self.items.count+1);
    CGFloat buttonH = self.bounds.size.height;
    int i = 0;
    for (UIControl *childView in self.subviews) {
        if ([childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (_previousClickedTabBarButton == nil && i == 0) {
                _previousClickedTabBarButton = childView;
            }
            if (i == 2) {
                i = i + 1;
            }
            CGRect frame = childView.frame;
            frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
            childView.frame = frame;
            
            i = i + 1;
            //GVLLog(@"%@",[childView superclass]);UIControl
            [childView addTarget:self action:@selector(tabBarCuttonClickAgain:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.publishButton.center = CGPointMake(self.gvl_width*0.5, self.gvl_height*0.5);
}
- (void)tabBarCuttonClickAgain:(UIControl *)tabBarButton{
    if (self.previousClickedTabBarButton == tabBarButton) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GVLTabBarButtonDidAgainClickNotification object:nil];
    }
    self.previousClickedTabBarButton = tabBarButton;
}

@end
