//
//  GVLSeeBigPictureController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/7/13.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLSeeBigPictureController.h"
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
#import <UIImageView+WebCache.h>
@interface GVLSeeBigPictureController ()<UIScrollViewDelegate>
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation GVLSeeBigPictureController
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)savePicture {
    GVLLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveButton.enabled = NO;
    //添加ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    scrollView.bounces = NO;
    _scrollView = scrollView;
    [self.view insertSubview:scrollView atIndex:0];
    
    //给ScrollView上面添加UIImageView或者FLAnimatedImageView
    if (self.noteMode.is_gif) {
        FLAnimatedImageView *flImageView = [[FLAnimatedImageView alloc] init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            FLAnimatedImage *flImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.noteMode.image1]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                flImageView.animatedImage = flImage;
            });
        });
        _imageView = flImageView;
        [scrollView addSubview:_imageView];
    }else{
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.noteMode.image1]];
        _imageView = imageView;
        [scrollView addSubview:_imageView];
    }
    //图片缩放
    CGFloat maxScale = self.noteMode.width/self.imageView.gvl_width;
    if (maxScale > 1) {
        self.scrollView.maximumZoomScale = maxScale;
        self.scrollView.delegate = self;
    }
}
# pragma mark -ScrollView代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)viewDidLayoutSubviews{
    self.scrollView.frame = self.view.bounds;
    self.imageView.gvl_x = 0;
    self.imageView.gvl_width = self.scrollView.gvl_width;
    self.imageView.gvl_height = self.noteMode.height * (self.imageView.gvl_width/self.noteMode.width);
    if (self.imageView.gvl_height > GVLScreenH) {
        self.imageView.gvl_y = 0;
        self.scrollView.contentSize = CGSizeMake(0, self.imageView.gvl_height);
    }else{
        self.imageView.gvl_centerY = self.scrollView.gvl_centerY;
    }
}

@end
