//
//  GVLNoteVideoView.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/11.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLNoteVideoView.h"
#import <UIImageView+WebCache.h>
@interface GVLNoteVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playVideoButton;

@end
@implementation GVLNoteVideoView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
}
- (void)setNoteMode:(GVLNoteModel *)noteMode{
    _noteMode = noteMode;
    //设置图片
    self.placeholderImageView.hidden = NO;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:noteMode.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(!image) return;
        self.imageView.image = image;
        self.placeholderImageView.hidden = YES;
    }];
    //设置播放量
    NSInteger playCount = noteMode.playcount;
    if (playCount > 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%1.f万播放",playCount/10000.0];
    }else{
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", playCount];
    }
    //设置播放时长
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",noteMode.videotime/60, noteMode.videotime%60];
}
@end
