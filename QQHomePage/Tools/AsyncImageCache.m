//
//  AsyncImageCache.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/27.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "AsyncImageCache.h"

@implementation AsyncImageCache

+ (instancetype)shareCache {
    static dispatch_once_t onceToken;
    static AsyncImageCache *cache;
    dispatch_once(&onceToken, ^{
        cache = [[AsyncImageCache alloc] init];
    });
    return cache;
}

@end
