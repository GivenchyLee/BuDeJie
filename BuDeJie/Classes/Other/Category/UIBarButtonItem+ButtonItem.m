//
//  UIBarButtonItem+ButtonItem.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/15.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "UIBarButtonItem+ButtonItem.h"

@implementation UIBarButtonItem (ButtonItem)
+ (instancetype)barButtonItemWithImageName:(NSString *)name highlightImageName:(NSString *)highName target:(id)target action:(SEL)action{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:highName] forState:UIControlStateHighlighted];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    //按照上面的方法设置完了之后，确实能显示，点击。但是有个问题就是 当我们点击按钮的外面区域的时候也会触发按钮被点击。所以我们
    //觉得直接将按钮包装到UIBarButtonItem，系统可能做了些东西，所以为了解决这个问题
    //我们再在按钮的外面包装一层view
    UIView *leftBarButton = [[UIView alloc] initWithFrame:leftButton.bounds];
    [leftBarButton addSubview:leftButton];
    
    return [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];

}

+ (instancetype)barButtonItemWithImageName:(NSString *)name selectedImageName:(NSString *)selectedName target:(id)target action:(SEL)action{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    //按照上面的方法设置完了之后，确实能显示，点击。但是有个问题就是 当我们点击按钮的外面区域的时候也会触发按钮被点击。所以我们
    //觉得直接将按钮包装到UIBarButtonItem，系统可能做了些东西，所以为了解决这个问题
    //我们再在按钮的外面包装一层view
    UIView *leftBarButton = [[UIView alloc] initWithFrame:leftButton.bounds];
    [leftBarButton addSubview:leftButton];
    
    return [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
}

+ (instancetype)backButtonItemWithImageName:(NSString *)name highlightImageName:(NSString *)highName target:(id)target action:(SEL)action{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:highName] forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    [backButton sizeToFit];
    //还是那个点击按钮外边的部分区域还是会触发点击事件，所以这里继续包装了一层View
    UIView *backButtonContainer = [[UIView alloc] initWithFrame:backButton.bounds];
    [backButtonContainer addSubview:backButton];
    return [[UIBarButtonItem alloc] initWithCustomView:backButtonContainer];
}
@end
