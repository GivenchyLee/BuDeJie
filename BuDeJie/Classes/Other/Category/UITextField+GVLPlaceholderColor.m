//
//  UITextField+GVLPlaceholderColor.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/23.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "UITextField+GVLPlaceholderColor.h"
#import <objc/message.h>
@implementation UITextField (GVLPlaceholderColor)

+ (void)load{
    Method setPlaceholderM = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setGVLPlaceholderM = class_getInstanceMethod(self, @selector(setGVLPlaceholder:));
    method_exchangeImplementations(setPlaceholderM, setGVLPlaceholderM);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    //这样子写有一个bug就是当该方法在设置占位文字之前执行的话，代码UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];获取的值为nil，所以下来也就不能成功的改变占位文字的颜色了
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
    
    //为了解决这个问题，我们在这个方法里面只是将用户想要设置的颜色用运行时保存为当前类的一个属性，当用后设置了占位文字的时候我们在取出来这个属性，改变占位文字label的textcolor。
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

- (void)setGVLPlaceholder:(NSString *)placeholder{
    [self setGVLPlaceholder:placeholder];
    self.placeholderColor = self.placeholderColor;
}
@end
