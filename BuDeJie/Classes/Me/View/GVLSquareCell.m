//
//  GVLSquareCell.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/25.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLSquareCell.h"
#import <UIImageView+WebCache.h>
@interface GVLSquareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end
@implementation GVLSquareCell
- (void)setCellMode:(GVLSquareCellModel *)cellMode{
    _cellMode = cellMode;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:cellMode.icon]];
    _nameView.text = cellMode.name;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
