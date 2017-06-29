//
//  GVLSubTagCell.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/21.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLSubTagCell.h"
#import <UIImageView+WebCache.h>
@interface GVLSubTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *discribeNumView;
    
@end
@implementation GVLSubTagCell
- (void)setFrame:(CGRect)frame{
    frame.size.height = frame.size.height - 1;
    [super setFrame:frame];
}
- (void)setSubTagModel:(GVLSubTagModel *)subTagModel{
    _subTagModel = subTagModel;
    _nameView.text = subTagModel.theme_name;
    //调整订阅数字显示格式
    [self modifySubscribeNumber];
    //裁剪图片步骤
    [self clipIconImage];

}

- (void)clipIconImage{
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_subTagModel.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //1.开启图形上下文
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        //2.描述裁剪区域
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        //3.设置裁剪区域
        [clipPath addClip];
        //4.画图像
        [image drawAtPoint:CGPointZero];
        //5.取出图片
        image = UIGraphicsGetImageFromCurrentImageContext();
        //6.关闭图形上下文
        UIGraphicsEndImageContext();
        
        //***裁剪完成后还需要在这把这个裁剪得到的图片赋值给iconView
        _iconView.image = image;
        
    }];
}
- (void)modifySubscribeNumber{
    NSString *numString = [NSString stringWithFormat:@"%@人订阅",_subTagModel.sub_number];
    NSInteger subscribeNumber = [_subTagModel.sub_number integerValue];
    if (subscribeNumber > 10000) {
        numString = [NSString stringWithFormat:@"%.1f万人订阅", subscribeNumber/10000.0];
        numString = [numString stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    _discribeNumView.text = numString;
    _discribeNumView.font = [UIFont systemFontOfSize:14];
    _discribeNumView.textColor = GVLColor(175, 175, 175);
}
//从xib加载就会调用这个方法
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
