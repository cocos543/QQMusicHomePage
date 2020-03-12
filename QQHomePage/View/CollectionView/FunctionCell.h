//
//  FunctionCell.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// QQ音乐头部那几个图标, 名字真难取
@interface FunctionCell : UITableViewCell

/// 先用collection view实现
@property (nonatomic, strong) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
