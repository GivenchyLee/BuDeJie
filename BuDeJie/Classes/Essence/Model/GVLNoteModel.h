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
@end
