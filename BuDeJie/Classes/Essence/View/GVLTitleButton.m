
//
//  GVLTitleButton.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/29.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLTitleButton.h"

@implementation GVLTitleButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];        
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
