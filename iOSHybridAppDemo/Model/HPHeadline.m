//
//  HPHeadline.m
//  iOS Hybrid App Demo
//
//  Created by apple on 15/1/24.
//  Copyright (c) 2015年 shaun All rights reserved.
//

#import "HPHeadline.h"

@implementation HPHeadline
+ (instancetype)headlineWithDict:(NSDictionary *)dict
{
    HPHeadline *headline = [[self alloc] init];
    headline.docid = dict[@"docid"];
    headline.title = dict[@"title"];
    headline.digest = dict[@"digest"];
    headline.imgsrc = dict[@"imgsrc"];
    return headline;
}
@end
