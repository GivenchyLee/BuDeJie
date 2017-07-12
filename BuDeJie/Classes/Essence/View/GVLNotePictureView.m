

//
//  GVLNotePictureView.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/11.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLNotePictureView.h"
#import <UIImageView+WebCache.h>

@interface GVLNotePictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPicButton;

@end
@implementation GVLNotePictureView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.seeBigPicButton.titleEdgeInsets = UIEdgeInsetsMake(0, GVLMargin*0.5, 0, 0);
    self.seeBigPicButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, GVLMargin*0.5);
    
}
- (void)setNoteMode:(GVLNoteModel *)noteMode{
    _noteMode = noteMode;
    GVLLog(@"%@,%@",noteMode.text, noteMode.image1);
    //设置图片
    self.placeholderImageView.hidden = NO;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:noteMode.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(!image) return;
        //处理一下超长图片用服务器放回的宽和高等比例的重新画一个图片，宽是中间内容的宽，高对应的比例变化
        CGFloat newImageW = noteMode.middleContentFrame.size.width;
        CGFloat newImageH = noteMode.height * (newImageW/noteMode.width);
        UIGraphicsBeginImageContext(CGSizeMake(newImageW, newImageH));
        [self.imageView.image drawInRect:CGRectMake(0, 0, newImageW, newImageH)];
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        self.placeholderImageView.hidden = YES;
    }];
    //判断是不是显示gif那个控件
    self.gifImageView.hidden = !noteMode.is_gif;
    //是不是显示底下那个点击查看大图控件
    if (noteMode.isBigPic) {
        self.seeBigPicButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    }
    else{
        self.seeBigPicButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
}
@end
