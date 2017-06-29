//
//  UIImage+Render.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/14.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "UIImage+Render.h"

@implementation UIImage (Render)
+ (instancetype)imageWithoutRendering:(NSString *)imageName{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
