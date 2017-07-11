//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/15.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property CGFloat gvl_width;
@property CGFloat gvl_height;
@property CGFloat gvl_x;
@property CGFloat gvl_y;
@property CGFloat gvl_centerX;
@property CGFloat gvl_centerY;

//从xib加载View
+ (instancetype)gvl_ViewFromXib;
@end
