//
//  JsonLoader.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/16.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonLoader : NSObject

/// json文件的根路径
@property (nonatomic, strong) NSString *baseUrl;

+ (NSArray *)jsonObjsWithFileName:(NSString *)name;

+ (instancetype)shareLoader;

@end

NS_ASSUME_NONNULL_END
