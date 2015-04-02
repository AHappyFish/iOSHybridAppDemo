//
//  HPNewsDetailImg.m
//  iOS Hybrid App Demo
//
//  Created by apple on 15/1/24.
//  Copyright (c) 2015年 shaun All rights reserved.
//

#import "HPNewsDetailImg.h"

@implementation HPNewsDetailImg

+ (instancetype)detailImgWithDict:(NSDictionary *)dict
{
    HPNewsDetailImg *img = [[self alloc] init];
    img.pixel = dict[@"pixel"];
    img.src = dict[@"src"];
    img.ref = dict[@"ref"];
    return img;
}
@end
