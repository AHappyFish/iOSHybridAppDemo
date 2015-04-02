//
//  HPHttpManager.m
//  iOS Hybrid App Demo
//
//  Created by apple on 15/1/24.
//  Copyright (c) 2015年 shaun All rights reserved.
//

#import "HPHttpManager.h"

@implementation HPHttpManager
+ (instancetype)manager {
    HPHttpManager *mgr = [super manager];
    
    NSMutableSet *newSet = [NSMutableSet set];
    newSet.set = mgr.responseSerializer.acceptableContentTypes;
    [newSet addObject:@"text/html"];
    [newSet addObject:@"text/plain"];
    mgr.responseSerializer.acceptableContentTypes = newSet;
    return mgr;
}
@end
