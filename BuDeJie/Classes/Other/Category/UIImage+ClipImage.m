//
//  UIImage+ClipImage.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/9.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "UIImage+ClipImage.h"

@implementation UIImage (ClipImage)
- (instancetype)gvl_clipCircularImage{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    //贝塞尔曲线描述裁剪去
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //裁剪路径添加形成裁剪区
    [clipPath addClip];
    //画图片
    [self drawAtPoint:CGPointZero];
    //取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}
+ (instancetype)gvl_clipCircularImageWithImageName:(NSString *)imageName{
    return [[self imageNamed:imageName] gvl_clipCircularImage];
}
@end
