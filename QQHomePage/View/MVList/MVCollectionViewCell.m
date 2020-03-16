//
//  MVCollectionViewCell.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/16.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "MVCollectionViewCell.h"

@implementation MVCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgV.layer.cornerRadius = 10.f;
    self.imgV.layer.masksToBounds = YES;
    
    self.iconV.layer.cornerRadius = self.iconV.frame.size.width / 2;
    self.iconV.layer.masksToBounds = YES;
}

@end
