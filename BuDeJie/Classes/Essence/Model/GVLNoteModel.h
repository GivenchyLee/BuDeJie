//
//  GVLNoteModel.h
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/9.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import <Foundation/Foundation.h>

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

/*
 这个并不是服务器返回来数据里面的属性
 为了优化GVLAllViewController里面的heightForRow方法，将计算对应模型的cell高度的代码封装到模型的一个属性
*/
@property(nonatomic, assign) CGFloat cellHeight;
@end
