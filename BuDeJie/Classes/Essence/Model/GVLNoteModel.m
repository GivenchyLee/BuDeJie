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
    CGSize textMaxSize = CGSizeMake(GVLScreemW, MAXFLOAT);
    CGFloat textHeight = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height;
    //在加上文字下边距
    _cellHeight = _cellHeight + textHeight + GVLMargin;
    
    //下面的工具条高度
    _cellHeight += 35;
    
    //由于setFrame里面减去了一个Margin的高度，这里应该加上那个Margin，才不会导致setFrame里面减操作完了对里面高度的影响
    _cellHeight += GVLMargin;
    
    return _cellHeight;
}
@end
