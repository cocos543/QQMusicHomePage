//
//  VIP1CollectionViewCell.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/17.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

NS_ASSUME_NONNULL_BEGIN

/// cell内部固定三个图片和标题, 作为Demo这里简单作为属性设置即可, 不考虑复用扩展!
@interface VIP1CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *videoArry;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutletCollection(AsyncImageView) NSArray *imgViewArr;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *itemsTitleArr;

/// 覆盖整个视图的背景图片
@property (weak, nonatomic) IBOutlet AsyncImageView *bigImgView;

@end

NS_ASSUME_NONNULL_END
