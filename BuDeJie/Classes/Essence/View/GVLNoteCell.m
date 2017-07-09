//
//  GVLNoteCell.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/9.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLNoteCell.h"
#import <UIImageView+WebCache.h>
#import "UIImage+ClipImage.h"
@interface GVLNoteCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@end
@implementation GVLNoteCell
//设置cell的背景图片，有于cell是通过nib加载的，所以会先进入awakeFromNib
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setNoteMode:(GVLNoteModel *)noteMode{
    _noteMode = noteMode;
    self.nameLabel.text = noteMode.name;
    self.passTimeLabel.text = noteMode.passtime;
    self.noteTextLabel.text = noteMode.text;
    [self setButtonTitle:self.dingButton title:noteMode.ding placeHolder:@"顶"];
    [self setButtonTitle:self.caiButton title:noteMode.cai placeHolder:@"踩"];
    [self setButtonTitle:self.repostButton title:noteMode.repost placeHolder:@"分享"];
    [self setButtonTitle:self.commentButton title:noteMode.comment placeHolder:@"评论"];
    //加载圆形图片
    UIImage *placeholder = [UIImage gvl_clipCircularImageWithImageName:@"defaultUserIcon"];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:noteMode.profile_image] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image == nil) {
            return;
        }
        self.profileImageView.image = [image gvl_clipCircularImage];
    }];
}
- (void)setButtonTitle:(UIButton *)button title:(NSString *)title placeHolder:(NSString *)placeHolder{
    NSInteger titleNumber = [title integerValue];
    if (titleNumber > 10000) {
        title = [NSString stringWithFormat:@"%.1f万", titleNumber/10000.0];
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }else if(titleNumber == 0){
        title = placeHolder;
    }
    [button setTitle:title forState:UIControlStateNormal];
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -= 10;
    [super setFrame:frame];
}
@end
