//
//  AsyncImageView.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/21.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "AsyncImageView.h"
#import "YYAsyncLayer.h"
#import "AsyncImageCache.h"

#import <SDWebImageManager.h>

@interface AsyncImageView () {
    BOOL _flag;
    CGFloat *_colors;
}

@end

@implementation AsyncImageView
@synthesize maskColors = _maskColors;

+ (Class)layerClass {
    return YYAsyncLayer.class;
}

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

- (void)dealloc {
    free(_colors);
    _colors = NULL;
}

- (void)initialize {
    self.layer.contentsScale = UIScreen.mainScreen.scale;

    [self setMaskColors:@[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1],
                          [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]]];
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;

    UIImage *cacheImage = [AsyncImageCache.shareCache objectForKey:imageURL.absoluteString];
    if (cacheImage) {
        self.layer.contents = (id)cacheImage.CGImage;
    } else {
        __weak __typeof(self) wself = self;
        [SDWebImageManager.sharedManager loadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *_Nullable image, NSData *_Nullable data, NSError *_Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL *_Nullable imageURL) {
            if (!error) {
                wself.image = image;
                [wself.layer setNeedsDisplay];
            }
        }];
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.layer setNeedsDisplay];
}

- (void)setMaskColors:(NSArray *)maskColors {
    _maskColors = maskColors;
    if (_colors) {
        free(_colors);
        _colors = NULL;
    }

    _colors = malloc(sizeof(CGFloat) * _maskColors.count * 4);
    for (int i = 0; i < _maskColors.count; i++) {
        UIColor *color = _maskColors[i];
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        _colors[i * 4 + 0] = components[0];
        _colors[i * 4 + 1] = components[1];
        _colors[i * 4 + 2] = components[2];
        _colors[i * 4 + 3] = components[3];
    }
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
    // 在主线程访问bounds属性
    CGRect bounds = self.bounds;

    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];

    task.willDisplay = ^(CALayer *layer) {};

    task.display     = ^(CGContextRef context, CGSize size, BOOL (^isCancelled)(void)) {
        if (isCancelled()) return;

        CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.asyncCornerRadius].CGPath);

        // 注意必须在把图片绘制到上下文之前就切割好绘制区域. 否则切割只对后续的绘制生效, 对已经绘制好的图片不生效.
        CGContextClip(context);

        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, bounds, self.image.CGImage);
        CGContextRestoreGState(context);

        if (self.drawMask) {
            CGColorSpaceRef rgb    = CGColorSpaceCreateDeviceRGB();

            CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, self->_colors, NULL, self.maskColors.count);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(size.width / 2, 0), CGPointMake(size.width / 2, size.height), 0);
            CGGradientRelease(gradient);
            CGColorSpaceRelease(rgb);
        }
    };

    task.didDisplay = ^(CALayer *layer, BOOL finished) {
        if (finished) {
            UIImage *image = [UIImage imageWithCGImage:(__bridge CGImageRef)layer.contents];
            [AsyncImageCache.shareCache setObject:image forKey:self.imageURL.absoluteString];

            [SDWebImageManager.sharedManager.imageCache removeImageForKey:self.imageURL.absoluteString cacheType:SDImageCacheTypeMemory completion:nil];
        }
    };

    return task;
}

@end
