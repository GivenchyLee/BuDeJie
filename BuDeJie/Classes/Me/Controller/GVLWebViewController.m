//
//  GVLWebViewController.m
//  BuDeJie
//
//  Created by GivenchyLee on 2017/6/29.
//  Copyright © 2017年 GivenchyLee. All rights reserved.
//

#import "GVLWebViewController.h"
#import <WebKit/WebKit.h>
@interface GVLWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardButtonItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressLine;
@end

@implementation GVLWebViewController
- (IBAction)goBackButtonItemClick:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForwardButtonItemClick:(id)sender {
    [self.webView goForward];
}
- (IBAction)refreshButtonItemClick:(id)sender {
    [self.webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    WKWebView *webView = [[WKWebView alloc] init];
    _webView = webView;
    [self.contentView addSubview:webView];
    
    //加载网页内容
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:self.url]];
    //kvo
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    GVLLog(@"%d,%d", self.webView.canGoForward, self.webView.canGoBack);
    _goBackButtonItem.enabled = self.webView.canGoBack;
    _goForwardButtonItem.enabled = self.webView.canGoForward;
    [_progressLine setProgress:self.webView.estimatedProgress animated:YES];
    _progressLine.hidden = self.webView.estimatedProgress >= 1;
    //进度条执行完成后，隐藏进度条
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _webView.frame = self.contentView.frame;
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
