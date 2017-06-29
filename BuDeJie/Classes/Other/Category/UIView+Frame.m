//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/15.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (CGFloat)gvl_width{
    return self.frame.size.width;
}
- (void)setGvl_width:(CGFloat)gvl_width{
    CGRect frame = self.frame;
    frame.size.width = gvl_width;
    self.frame = frame;
}

- (CGFloat)gvl_height{
    return self.frame.size.height;
}
- (void)setGvl_height:(CGFloat)gvl_height{
    CGRect frame = self.frame;
    frame.size.height = gvl_height;
    self.frame = frame;
}

- (CGFloat)gvl_x{
    return self.frame.origin.x;
}
- (void)setGvl_x:(CGFloat)gvl_x{
    CGRect frame = self.frame;
    frame.origin.x = gvl_x;
    self.frame = frame;
}

- (CGFloat)gvl_y{
    return self.frame.origin.y;
}
- (void)setGvl_y:(CGFloat)gvl_y{
    CGRect frame = self.frame;
    frame.origin.y = gvl_y;
    self.frame = frame;
}

- (CGFloat)gvl_centerX{
    return self.center.x;
}
- (void)setGvl_centerX:(CGFloat)gvl_centerX{
    CGPoint center = self.center;
    center.x = gvl_centerX;
    self.center = center;
}
- (CGFloat)gvl_centerY{
    return self.center.y;
}
- (void)setGvl_centerY:(CGFloat)gvl_centerY{
    CGPoint center = self.center;
    center.y = gvl_centerY;
    self.center = center;
}
@end
