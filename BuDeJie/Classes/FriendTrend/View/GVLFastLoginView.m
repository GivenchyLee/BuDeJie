//
//  GVLFastLoginView.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/23.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLFastLoginView.h"

@implementation GVLFastLoginView

+(instancetype)fastLoginView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
