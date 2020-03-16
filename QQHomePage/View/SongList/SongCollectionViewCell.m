//
//  SongCollectionViewCell.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/16.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "SongCollectionViewCell.h"

@implementation SongCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 图片圆角处理
    self.imgV.layer.cornerRadius = 10.f;
    self.imgV.layer.masksToBounds = YES;
    
    
    // 图片上方追加渐变灰度蒙版, 当前的maskV的尺寸假设已经符合要求了
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:0.1];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.2];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.3];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.7),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.zPosition = -1;
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = self.maskV.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(0, 1);
    [self.maskV.layer addSublayer:gradientLayer];
    self.maskV.layer.masksToBounds = YES;
    self.maskV.layer.cornerRadius = 10.f;
}


@end
