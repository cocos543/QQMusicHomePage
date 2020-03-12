//
//  TopicViewCell.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 话题界面需要有一个自定义布局的Collection来实现横向流式布局
@interface TopicViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
