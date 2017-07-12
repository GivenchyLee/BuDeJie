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
#import "GVLNotePictureView.h"
#import "GVLNoteVideoView.h"
#import "GVLNoteVoiceView.h"
@interface GVLNoteCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCommentView;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
//调整底部工具条里面按钮中图片和文字之间的间距，拿到底部工具条
@property (weak, nonatomic) IBOutlet UIView *bottomToolBarView;



@property (weak, nonatomic) GVLNotePictureView *notePictureView;
@property (weak, nonatomic) GVLNoteVideoView *noteVideoView;
@property (weak, nonatomic) GVLNoteVoiceView *noteVoiceView;
@end
@implementation GVLNoteCell
#pragma mark -懒加载
- (UIView *)notePictureView{
    if (_notePictureView == nil) {
        _notePictureView = [GVLNotePictureView gvl_ViewFromXib];
        [self.contentView addSubview:_notePictureView];
    }
    return _notePictureView;
}
- (UIView *)noteVideoView{
    if (_noteVideoView == nil) {
        _noteVideoView = [GVLNoteVideoView gvl_ViewFromXib];
        [self.contentView addSubview:_noteVideoView];
    }
    return _noteVideoView;
}
- (UIView *)noteVoiceView{
    if (_noteVoiceView == nil) {
        _noteVoiceView = [GVLNoteVoiceView gvl_ViewFromXib];
        [self.contentView addSubview:_noteVoiceView];
    }
    return _noteVoiceView;
}
//设置cell的背景图片，有于cell是通过nib加载的，所以会先进入awakeFromNib
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    //调整里面按钮图片和文字之间的间距
    for (UIView *childView in self.bottomToolBarView.subviews) {
        if ([childView isMemberOfClass:[UIButton class]]) {
            UIButton *childButton = (UIButton *)childView;
            childButton.titleEdgeInsets = UIEdgeInsetsMake(0, GVLMargin*0.5, 0, 0);
            childButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, GVLMargin*0.5);
        }
    }
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
    //添加自定义中间的View
    //加载图片
    if (noteMode.type == GVLNoteTypePicture) {
        self.notePictureView.hidden = NO;
        self.noteVoiceView.hidden = YES;
        self.noteVideoView.hidden = YES;
        self.notePictureView.noteMode = noteMode;
    }else if(noteMode.type == GVLNoteTypeVideo){
        self.notePictureView.hidden = YES;
        self.noteVoiceView.hidden = YES;
        self.noteVideoView.hidden = NO;
        self.noteVideoView.noteMode = noteMode;
    }else if(noteMode.type == GVLNoteTypeVoice){
        self.notePictureView.hidden = YES;
        self.noteVoiceView.hidden = NO;
        self.noteVideoView.hidden = YES;
        self.noteVoiceView.noteMode = noteMode;
    }else if(noteMode.type == GVLNoteTypeWord){
        self.notePictureView.hidden = YES;
        self.noteVoiceView.hidden = YES;
        self.noteVideoView.hidden = YES;
    }
    
    //显示最热评论内容,由于返回的数组中只有一个元素，用firstObject拿出来
    if (noteMode.top_cmt.count) {
        self.topCommentView.hidden = NO;
        NSDictionary *commentDict = [noteMode.top_cmt firstObject];
        NSString * commentUser = commentDict[@"user"][@"username"];
        NSString * commentContent = commentDict[@"content"];
        if (commentContent.length == 0) {
            commentContent = @"[语音评论]";
        }
        self.commentContentLabel.text = [NSString stringWithFormat:@"%@ : %@",commentUser, commentContent];
    }else{
        self.topCommentView.hidden = YES;
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.noteMode.type == GVLNoteTypePicture) {
        self.notePictureView.frame = self.noteMode.middleContentFrame;

    }else if(self.noteMode.type == GVLNoteTypeVideo){
        self.noteVideoView.frame = self.noteMode.middleContentFrame;
    }else if(self.noteMode.type == GVLNoteTypeVoice){
        self.noteVoiceView.frame = self.noteMode.middleContentFrame;
    }
    
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -= GVLMargin;
    [super setFrame:frame];
}
@end
