//
//  VIP1CollectionViewCell.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/17.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "VIP1CollectionViewCell.h"

@implementation VIP1CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 大背景图上面盖一个灰色半透明蒙版, 不然背景图太显眼了
    CALayer *layer = CALayer.new;
    // 这里同样需要实现计算好frame的大小, demo中frame的大小和nib文件中的一样
    layer.frame = self.bigImgView.bounds;
    layer.backgroundColor = [UIColor cc_stringToColor:@"#000000" opacity:0.5].CGColor;
    [self.bigImgView.layer addSublayer:layer];
    
    self.bigImgView.layer.cornerRadius = 10.f;
    self.bigImgView.layer.masksToBounds = YES;
    
    for (UIView *v in self.imgViewArr) {
        v.layer.cornerRadius = 10.f;
        v.layer.masksToBounds = YES;
    }
    
}

@end
