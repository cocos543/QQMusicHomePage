//
//  SongCollectionViewCell.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/16.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

NS_ASSUME_NONNULL_BEGIN

/// 用来显示具体单个歌单的UI
@interface SongCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *maskV;
@property (weak, nonatomic) IBOutlet AsyncImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *listenNumLabel;


@end

NS_ASSUME_NONNULL_END
