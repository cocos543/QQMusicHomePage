//
//  AsyncTopicView.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/18.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "AsyncTopicView.h"
#import "YYAsyncLayer.h"

@implementation AsyncTopicView

+ (Class)layerClass {
    return YYAsyncLayer.class;
}

- (void)layoutSubviews {
    [self.layer setNeedsDisplay];
}

- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer *layer) {
        
    };
    
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
        if (isCancelled()) return;
        NSLog(@"开始显示");
    };
    
    task.didDisplay = ^(CALayer *layer, BOOL finished) {
        if (finished) {
            // finished
        } else {
            // cancelled
        }
    };
    
    return task;
}

@end
