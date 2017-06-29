//
//  GVLFastButton.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/23.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLFastButton.h"

@implementation GVLFastButton

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.gvl_y = 0;
    self.imageView.gvl_centerX = self.gvl_width*0.5;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.gvl_y = self.gvl_height - self.titleLabel.gvl_height;
    self.titleLabel.gvl_centerX = self.gvl_width*0.5;
    
}

@end
