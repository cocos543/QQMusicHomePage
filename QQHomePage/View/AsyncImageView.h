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

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGFloat asyncCornerRadius;


// 绘制蒙版, 默认YES
@property (nonatomic, assign) BOOL drawMask;

@end

NS_ASSUME_NONNULL_END
