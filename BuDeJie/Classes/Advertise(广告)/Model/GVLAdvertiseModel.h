//
//  GVLAdvertiseModel.h
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/17.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import <Foundation/Foundation.h>
//w_picurl广告背景图片URL
//ori_curl点击广告跳转的页面URL
//w 广告背景图片的宽度
//h 广告背景图片的高度
@interface GVLAdvertiseModel : NSObject
@property(nonatomic, copy) NSString *w_picurl;
@property(nonatomic, copy) NSString *ori_curl;
@property(nonatomic, assign) CGFloat w;
@property(nonatomic, assign) CGFloat h;
@end
