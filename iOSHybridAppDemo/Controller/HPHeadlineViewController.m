//
//  HPHeadlineViewController.m
//  iOS Hybrid App Demo
//
//  Created by apple on 15/1/24.
//  Copyright (c) 2015年 shaun All rights reserved.
//

#import "HPHeadlineViewController.h"
#import "HPNewsDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HPHttpManager.h"
#import "HPHeadline.h"

@interface HPHeadlineViewController ()
@property (nonatomic, strong) NSArray *headlines;
@end

@implementation HPHeadlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 70;
    
    [[HPHttpManager manager] GET:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-140.html" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 新闻字典数组
        NSArray *dictArray = responseObject[@"T1348647853363"];
        
        // 新闻模型数组
        NSMutableArray *headlines = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            HPHeadline *headline = [HPHeadline headlineWithDict:dict];
            [headlines addObject:headline];
        }
        self.headlines = headlines;
        
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败 - %@", error);
    }];
}

#pragma mark - 在跳转之前的准备工作
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HPNewsDetailViewController *newsDetails = segue.destinationViewController;
    NSUInteger row = self.tableView.indexPathForSelectedRow.row;
    newsDetails.headline = self.headlines[row];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headlines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headline"];
    
    HPHeadline *headline = self.headlines[indexPath.row];
    cell.textLabel.text = headline.title;
    cell.detailTextLabel.text = headline.digest;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headline.imgsrc] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    return cell;
}
@end
