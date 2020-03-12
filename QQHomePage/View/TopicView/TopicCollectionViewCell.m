//
//  TopicCollectionViewCell.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "TopicCollectionViewCell.h"

@implementation TopicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor cc_stringToColor:@"#F1F2F3" opacity:1];
        self.layer.cornerRadius = 12.5;
        self.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFontSize:13 color:[UIColor cc_stringToColor:@"#444444" opacity:1]];
    }
    return _titleLabel;
}

@end
