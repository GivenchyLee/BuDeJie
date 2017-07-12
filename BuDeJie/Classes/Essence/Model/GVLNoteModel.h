//
//  GVLNoteModel.h
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/9.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef enum{
//    GVLNoteTypeAll = 1,
//    GVLNoteTypePicture = 10,
//    GVLNoteTypeWord = 29,
//    GVLNoteTypeVoice = 31,
//    GVLNoteTypeVedio = 41
//}GVLNoteType;

typedef NS_ENUM(NSInteger, GVLNoteType){
    GVLNoteTypeAll = 1,
    GVLNoteTypePicture = 10,
    GVLNoteTypeWord = 29,
    GVLNoteTypeVoice = 31,
    GVLNoteTypeVideo = 41
};
@interface GVLNoteModel : NSObject
//用户名称
@property(nonatomic, copy) NSString *name;
//用户头像
@property(nonatomic, copy) NSString *profile_image;
//帖子审核通过的时间
@property(nonatomic, copy) NSString *passtime;
//帖子内容
@property(nonatomic, copy) NSString *text;
//踩的数量
@property(nonatomic, assign) NSString *cai;
//顶的数量
@property(nonatomic, assign) NSString *ding;
//转发的数量
@property(nonatomic, assign) NSString *repost;
//评论的数量
@property(nonatomic, assign) NSString *comment;
//服务器返回最热评论数组
@property(nonatomic, strong) NSArray *top_cmt;
//服务器返回中间内容的宽和高
@property(nonatomic, assign) NSInteger height;
@property(nonatomic, assign) NSInteger width;
//服务器返回帖子的类型
@property(nonatomic, assign) NSInteger type;

//videoXib或者voiceXib需要的属性
@property(nonatomic, assign) NSInteger playcount;
@property(nonatomic, assign) NSInteger videotime;
@property(nonatomic, assign) NSInteger voicetime;
//小图
@property(nonatomic, copy) NSString *image0;
//中图
@property(nonatomic, copy) NSString *image2;
//大图
@property(nonatomic, copy) NSString *image1;

//pictureXib需要的属性
//是否为GIF图片
@property(nonatomic, assign) BOOL is_gif;
/*
 这个并不是服务器返回来数据里面的属性
 为了优化GVLAllViewController里面的heightForRow方法，将计算对应模型的cell高度的代码封装到模型的一个属性
*/
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, assign) CGRect middleContentFrame;
@property(nonatomic, assign, getter=isBigPic) BOOL isBigPic;
@end
