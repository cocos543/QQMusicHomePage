//
//  TopicWalterfallFlowLayout.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TopicWalterfallFlowLayoutDataSource <NSObject>

/// 数据源需要实现该方法, 提供每一个item的宽度
- (CGFloat)topicWalterFallItemContentWidthAtIndexPath:(NSIndexPath *)indexPath;

/// 提供行数
- (NSInteger)topicWalterFallItemRowNumber;

@end

/// 支持topic界面的横向流式布局
@interface TopicWalterfallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<TopicWalterfallFlowLayoutDataSource> dataSource;

/// 行间距
@property (nonatomic, assign) CGFloat lineDistance;

/// 元素横向间距
@property (nonatomic, assign) CGFloat itemDistance;

@end

NS_ASSUME_NONNULL_END
