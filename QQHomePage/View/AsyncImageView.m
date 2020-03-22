//
//  AsyncImageView.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/21.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "AsyncImageView.h"
#import "YYAsyncLayer.h"
#import <SDWebImageManager.h>

@interface AsyncImageView () {
    BOOL _flag;
}

@end

@implementation AsyncImageView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.drawMask = YES;
    self.layer.contentsScale = UIScreen.mainScreen.scale;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    
    __weak __typeof(self)wself = self;
    
    [SDWebImageManager.sharedManager downloadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        wself.image = image;
        [wself.layer setNeedsDisplay];
    }];
}

+ (Class)layerClass {
    return YYAsyncLayer.class;
}


// - (void)displayLayer:(CALayer *)layer {
//     UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
//     CGContextRef ctx = UIGraphicsGetCurrentContext();
//     CGContextGetClipBoundingBox(ctx);
//
//     CGContextAddPath(ctx, [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.asyncCornerRadius].CGPath);
//     CGContextClip(ctx);
//
//     CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
//     CGContextScaleCTM(ctx, 1.0, -1.0);
//     CGContextDrawImage(ctx, self.bounds, self.image.CGImage);
//
//     UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//
//     UIGraphicsEndImageContext();
//     layer.contentsGravity = kCAGravityCenter;
//     layer.contentsScale = 3;
//     layer.contents = (id)img.CGImage;
// }
 


- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer *layer) {};
    
    
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
        if (isCancelled()) return;
        
        CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.asyncCornerRadius].CGPath);
        
        // 注意必须在把图片绘制到上下文之前就切割好绘制区域. 否则切割只对后续的绘制生效, 对已经绘制好的图片不生效.
        CGContextClip(context);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, self.bounds, self.image.CGImage);
        CGContextRestoreGState(context);
        
        if (self.drawMask) {
            CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
            CGFloat colors[] = {
                0, 0, 0, 0.1,//start color(r,g,b,alpha)
                0, 0, 0, 0.4,//end color
            };
            
            CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(size.width / 2, 0), CGPointMake(size.width / 2, size.height), 0);
            
            CGGradientRelease(gradient);
            CGColorSpaceRelease(rgb);
        }
        
    };
    
    task.didDisplay = ^(CALayer *layer, BOOL finished) {};
    
    
    return task;
}


@end
