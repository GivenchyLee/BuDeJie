

//
//  GVLNotePictureView.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/11.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLNotePictureView.h"
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
#import <UIImageView+WebCache.h>
#import "GVLSeeBigPictureController.h"

@interface GVLNotePictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPicButton;

@end
@implementation GVLNotePictureView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    //self.imageView.userInteractionEnabled = YES;
    self.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.seeBigPicButton.titleEdgeInsets = UIEdgeInsetsMake(0, GVLMargin*0.5, 0, 0);
    self.seeBigPicButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, GVLMargin*0.5);
    //添加手势，让手势可以传统seeBigPicButton的拦截
    //或者addtarget直接调用seeBigPicture方法也行
    self.seeBigPicButton.userInteractionEnabled = NO;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
    
}
- (void)seeBigPicture{
    //modal出来我们定义的GVLSeeBigPictureController
    GVLSeeBigPictureController *seeBigPicController = [[GVLSeeBigPictureController alloc] init];
    seeBigPicController.noteMode = self.noteMode;
    [self.window.rootViewController presentViewController:seeBigPicController animated:YES completion:nil];
}
- (void)setNoteMode:(GVLNoteModel *)noteMode{
    _noteMode = noteMode;
//    GVLLog(@"%@,%@",noteMode.text, noteMode.image1);
    //设置图片
    self.placeholderImageView.hidden = NO;
    if (noteMode.is_gif) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            FLAnimatedImage *flImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:noteMode.image1]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.animatedImage = flImage;
            });
        });
    }else{
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
    }
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
