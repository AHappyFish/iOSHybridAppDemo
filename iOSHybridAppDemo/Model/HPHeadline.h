//
//  HPHeadline.h
//  iOS Hybrid App Demo
//
//  Created by apple on 15/1/24.
//  Copyright (c) 2015年 shaun All rights reserved.
//

#import <Foundation/Foundation.h>
@class HPNewsDetail;

@interface HPHeadline : NSObject
/** 新闻ID */
@property (nonatomic, copy) NSString *docid;
/** 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 新闻摘要 */
@property (nonatomic, copy) NSString *digest;
/** 新闻配图 */
@property (nonatomic, copy) NSString *imgsrc;

+ (instancetype)headlineWithDict:(NSDictionary *)dict;
@end