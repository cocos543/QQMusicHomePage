//
//  BaseTableViewCell.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/16.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *listJson;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)updateItemSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
