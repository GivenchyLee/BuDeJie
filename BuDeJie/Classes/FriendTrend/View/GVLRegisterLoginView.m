//
//  GVLRegisterLoginView.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/22.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLRegisterLoginView.h"
@interface GVLRegisterLoginView ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
@implementation GVLRegisterLoginView

+ (instancetype)loginView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
+ (instancetype)registerView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    UIImage *currentBackgroundImage = _loginButton.currentBackgroundImage;
    [_loginButton setBackgroundImage:[currentBackgroundImage stretchableImageWithLeftCapWidth:currentBackgroundImage.size.width*0.5 topCapHeight:currentBackgroundImage.size.height*0.5] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[currentBackgroundImage stretchableImageWithLeftCapWidth:currentBackgroundImage.size.width*0.5 topCapHeight:currentBackgroundImage.size.height*0.5] forState:UIControlStateHighlighted];
}
@end
