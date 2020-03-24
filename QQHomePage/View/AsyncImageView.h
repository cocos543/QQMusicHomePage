//
//  AsyncImageView.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/21.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsyncImageView : UIView

// 设置图片的时候才会开始绘制
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGFloat asyncCornerRadius;


// 绘制蒙版, 默认NO
@property (nonatomic, assign) BOOL drawMask;

// 蒙版颜色组, 为nil时, 默认绘制灰色渐变蒙版
@property (nonatomic, strong) NSArray *maskColors;

@end

NS_ASSUME_NONNULL_END
