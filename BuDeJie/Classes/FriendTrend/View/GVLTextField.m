//
//  GVLTextField.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/23.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLTextField.h"
#import "UITextField+GVLPlaceholderColor.h"
@implementation GVLTextField

-(void)awakeFromNib{
    [super awakeFromNib];
    //设置光标的颜色
    self.tintColor = [UIColor whiteColor];
    
    //设置占位文字的颜色
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
//    NSMutableDictionary *attributeDictM = [NSMutableDictionary dictionary];
//    attributeDictM[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributeDictM];
    
    //_placeholderLabel	id	0x0
//    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
//    placeholderLabel.textColor = [UIColor lightGrayColor];
    
    //能不能有一个这个方法 self.placeholderColor = [UIColor xxx];
    self.placeholderColor = [UIColor lightGrayColor];
}
- (void)textBegin{
    self.placeholderColor = [UIColor whiteColor];

}

- (void)textEnd{
    self.placeholderColor = [UIColor lightGrayColor];
}
@end
