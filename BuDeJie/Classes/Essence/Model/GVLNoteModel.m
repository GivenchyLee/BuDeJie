//
//  GVLNoteModel.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/9.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLNoteModel.h"

@implementation GVLNoteModel
- (CGFloat )cellHeight{
    if (_cellHeight) {
        return _cellHeight;
    }
    //文字顶部距离Xib的高度
    _cellHeight += 55;
    //中间文字的高度
    CGSize textMaxSize = CGSizeMake(GVLScreemW - 2*GVLMargin, MAXFLOAT);
    CGFloat textHeight = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height + GVLMargin;
    //在加上文字下边距
    _cellHeight += textHeight;
    
    
    //中间内容
    if (self.type != GVLNoteTypeWord) {
        CGFloat middleContentWidth = textMaxSize.width;
        CGFloat middleContentHeight = self.height * (middleContentWidth/self.width);
        //如果当前算出来的中间图片的高度大于了一个屏幕的高度，设置isBigPic为true;
        if (middleContentHeight > GVLScreenH) {
            self.isBigPic = true;
            middleContentHeight = 200;
        }
        self.middleContentFrame = CGRectMake(GVLMargin, _cellHeight, middleContentWidth, middleContentHeight);
        _cellHeight += middleContentHeight + GVLMargin;
    }
    
    
    
    //最热评论高度
    if (self.top_cmt.count) {
        //最新评论标题高度
        _cellHeight += 18;
        //最新评论内容高度计算
        NSDictionary *commentDict = [self.top_cmt firstObject];
        NSString * commentUser = commentDict[@"user"][@"username"];
        NSString * commentContent = commentDict[@"content"];
        if (commentContent.length == 0) {
            commentContent = @"[语音评论]";
        }
        CGFloat commentTextHeight = [[NSString stringWithFormat:@"%@ : %@",commentUser, commentContent] boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height + GVLMargin;
        
        _cellHeight += commentTextHeight;
    }
    //下面的工具条高度
    _cellHeight += 35;
    
    //由于setFrame里面减去了一个Margin的高度，这里应该加上那个Margin，才不会导致setFrame里面减操作完了对里面高度的影响
    _cellHeight += GVLMargin;
    
    return _cellHeight;
}
@end
