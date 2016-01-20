//
//  ScrollDetailVC.m
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "ScrollDetailVC.h"

@interface ScrollDetailVC ()<UIWebViewDelegate>
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation ScrollDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.activityIndicatorView];
    
    [self loadWebPageWithString:self.webUrlString];
}

#pragma mark - 懒加载
- (UIWebView *)webView {
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _webView.scalesPageToFit = YES;//页面自动缩放以适应屏幕
        _webView.delegate = self;
    }
    return _webView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        [_activityIndicatorView setCenter:self.view.center];//滚动轮显示位置
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//滚动轮样式
    }
    return _activityIndicatorView;
}

//网址加载
- (void)loadWebPageWithString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
#pragma mark - UIWebViewDelegate
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicatorView startAnimating];//启动滚动轮
}

//进行加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

//加载结束
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicatorView stopAnimating];//关闭滚动轮
}

//加载出错
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}



@end
