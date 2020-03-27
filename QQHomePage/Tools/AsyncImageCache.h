//
//  AsyncImageCache.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/27.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "SDMemoryCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface AsyncImageCache : SDMemoryCache

+ (instancetype)shareCache;

@end

NS_ASSUME_NONNULL_END
