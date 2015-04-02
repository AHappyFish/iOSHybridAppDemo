//
//  HPNewsDetail.m
//  iOS Hybrid App Demo
//
//  Created by apple on 15/1/24.
//  Copyright (c) 2015年 shaun All rights reserved.
//

#import "HPNewsDetail.h"
#import "HPNewsDetailImg.h"

@implementation HPNewsDetail
+ (instancetype)detailWithDict:(NSDictionary *)dict
{
    HPNewsDetail *detail = [[self alloc] init];
    detail.title = dict[@"title"];
    detail.ptime = dict[@"ptime"];
    detail.body = dict[@"body"];
    
    // 图片模型数组
    NSArray *imgDictArray = dict[@"img"];
    NSMutableArray *imgModelArray = [NSMutableArray array];
    for (NSDictionary *imgDict in imgDictArray) {
        HPNewsDetailImg *imgModel = [HPNewsDetailImg detailImgWithDict:imgDict];
        [imgModelArray addObject:imgModel];
    }
    detail.img = imgModelArray;
    
    return detail;
}
@end
