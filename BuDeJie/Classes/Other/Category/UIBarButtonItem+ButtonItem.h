//
//  UIBarButtonItem+ButtonItem.h
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/15.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ButtonItem)
+ (instancetype)barButtonItemWithImageName:(NSString *)name highlightImageName:(NSString *)highName target:(id)target action:(SEL)action;
+ (instancetype)backButtonItemWithImageName:(NSString *)name highlightImageName:(NSString *)highName target:(id)target action:(SEL)action;
+ (instancetype)barButtonItemWithImageName:(NSString *)name selectedImageName:(NSString *)selectedName target:(id)target action:(SEL)action;
@end
