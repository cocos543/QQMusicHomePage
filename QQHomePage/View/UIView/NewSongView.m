//
//  NewSongView.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "NewSongView.h"

@implementation NewSongView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

- (void)setImgV:(UIImageView *)imgV {
    _imgV = imgV;
    _imgV.layer.cornerRadius = 5;
    _imgV.layer.masksToBounds = YES;
}

@end
