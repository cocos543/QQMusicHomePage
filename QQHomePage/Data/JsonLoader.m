//
//  JsonLoader.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/16.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "JsonLoader.h"

@implementation JsonLoader


- (instancetype)init {
    self = [super init];
    if (self) {
        self.baseUrl = [NSBundle.mainBundle resourcePath];
    }
    return self;
}

+ (instancetype)shareLoader {
    static dispatch_once_t onceToken;
    static JsonLoader* loader;
    dispatch_once(&onceToken, ^{
        loader = JsonLoader.new;
    });
    return loader;
}

+ (NSArray *)jsonObjsWithFileName:(NSString *)name {
    NSString *path = [JsonLoader.shareLoader.baseUrl stringByAppendingPathComponent:name];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    if (err) {
        NSLog(@"%@", err);
    }
    return dic[@"data"][@"list"];
}

@end
