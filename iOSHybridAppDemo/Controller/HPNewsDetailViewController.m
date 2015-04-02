//
//  HPNewsDetailViewController.m
//  iOS Hybrid App Demo
//
//  Created by apple on 15/1/24.
//  Copyright (c) 2015年 shaun All rights reserved.
//

#import "HPNewsDetailViewController.h"
#import "HPHttpManager.h"
#import "HPHeadline.h"
#import "HPNewsDetail.h"
#import "HPNewsDetailImg.h"

@interface HPNewsDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) HPNewsDetail *detail;
@end

@implementation HPNewsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新闻详情";
    
    self.webView.delegate = self;
    
    // 发送一个GET请求, 获得新闻的详情数据
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", self.headline.docid];
    
    [[HPHttpManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        self.detail = [HPNewsDetail detailWithDict:responseObject[self.headline.docid]];
        [self showNewsDetail];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure - %@", error);
    }];
}

/**
 *  显示新闻详情数据
 */
- (void)showNewsDetail
{
    NSMutableString *html = [NSMutableString string];
    // 头部内容
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">", [[NSBundle mainBundle] URLForResource:@"HPNewsDetail.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    // 具体内容
    [html appendString:@"<body>"];
    
    // 将图片插入body对应的标记中, 比如<!--IMG#0-->
    [html appendString:[self setupBody]];
    
    [html appendString:@"</body>"];
    
    // 尾部内容
    [html appendString:@"</html>"];
    
    // 显示网页
    [self.webView loadHTMLString:html baseURL:nil];
}

/**
 *  初始化body内容
 */
- (NSString *)setupBody
{
    NSMutableString *body = [NSMutableString string];
    
    // 拼接标题
    [body appendFormat:@"<div class=\"title\">%@</div>", self.detail.title];
    
    // 拼接时间
    [body appendFormat:@"<div class=\"time\">%@</div>", self.detail.ptime];
    
    // 拼接图片
    [body appendString:self.detail.body];
    for (HPNewsDetailImg *img in self.detail.img) {
        // 图片的html字符串
        NSMutableString *imgHtml = [NSMutableString string];
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // img.pixel = 500*332
        NSArray *pixel = [img.pixel componentsSeparatedByString:@"*"];
        int width = [[pixel firstObject] intValue];
        int height = [[pixel lastObject] intValue];
        int maxWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
        if (width > maxWidth) { // 限制尺寸
            height = height * maxWidth / width;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
                            "   window.location.href = 'hp:src=' + this.src;"
                            "};";
        
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%d\" height=\"%d\" src=\"%@\">", onload, width, height, img.src];
        [imgHtml appendString:@"</div>"];
        
        // 将img.ref替换为img标签的内容
        [body replaceOccurrencesOfString:img.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

/**
 *  保存图片到相册
 *
 *  @param src 图片路径
 */
- (void)saveImageToAlbum:(NSString *)src
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"是否要保存图片到相册?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // UIWebView的缓存由NSURLCache来管理
        NSURLCache *cache = [NSURLCache sharedURLCache];
        
        // 从网页缓存中取得图片
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        
        // 保存图片
        UIImage *image = [UIImage imageWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
    
    // 显示
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <UIWebViewDelegate>
/**
 *  每当webView发送一个请求之前都会先调用这个方法
 *
 *  @param request        即将发送的请求
 *
 *  @return YES: 允许发送这个请求, NO: 禁止发送这个请求
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"hp:src="];
    if (range.location != NSNotFound) {
        NSUInteger loc = range.location + range.length;
        NSString *src = [url substringFromIndex:loc];
        // 保存图片
        [self saveImageToAlbum:src];
        return NO;
    }
    return YES;
}

@end
