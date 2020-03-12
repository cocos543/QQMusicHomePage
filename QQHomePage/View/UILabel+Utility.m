//
//  UILabel+Utility.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "UILabel+Utility.h"

@implementation UILabel (Utility)

+ (UILabel *)labelWithFontSize:(CGFloat)size color:(UIColor *)color {
    UILabel *label = UILabel.new;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
