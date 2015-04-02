//
//  HPNewsDetail.h
//  iOS Hybrid App Demo
//
//  Created by apple on 15/1/24.
//  Copyright (c) 2015年 shaun All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPNewsDetail : NSObject
/** 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 新闻发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 新闻内容 */
@property (nonatomic, copy) NSString *body;
/** 新闻配图(希望这个数组中以后放HPNewsDetailImg模型) */
@property (nonatomic, strong) NSArray *img;

+ (instancetype)detailWithDict:(NSDictionary *)dict;
@end
