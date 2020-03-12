//
//  TopicWalterfallFlowLayout.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "TopicWalterfallFlowLayout.h"

@interface TopicWalterfallFlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *itemAttributes;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *rowsMaxRightArray;

@end

@implementation TopicWalterfallFlowLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineDistance = 10;
        self.itemDistance = 10;
    }
    return self;
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)itemAttributes {
    if (!_itemAttributes) {
        _itemAttributes = @[].mutableCopy;
    }
    return _itemAttributes;
}

- (NSInteger)rowsNumber {
    return [self.dataSource topicWalterFallItemRowNumber];
}

- (NSMutableArray<NSNumber *> *)rowsMaxRightArray {
    if (!_rowsMaxRightArray) {
        _rowsMaxRightArray = @[].mutableCopy;
        for (NSInteger i = 0; i < [self rowsNumber]; i++) {
            [_rowsMaxRightArray addObject:@(self.sectionInset.left)];
        }
    }
    return _rowsMaxRightArray;
}


- (void)prepareLayout {
    [super prepareLayout];
    if ([self.dataSource topicWalterFallItemRowNumber] <= 0) {
        return;
    }
    
    // 这里只支持一个section的流式布局
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    
    // 记录下一个的item的原点
    
    CGFloat height = (self.collectionView.frame.size.height - self.sectionInset.top - self.sectionInset.bottom - ([self rowsNumber] - 1) * self.lineDistance) / [self rowsNumber];
    
    CGPoint origin = CGPointZero;
    for (NSInteger i = 0; i < itemsCount; i += [self rowsNumber]) {
        origin.y = self.sectionInset.top;
        
        for (NSInteger row = 0; row < [self rowsNumber]; row++) {
            origin.x = self.rowsMaxRightArray[row].doubleValue;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i+row inSection:0];
            CGFloat width = [self.dataSource topicWalterFallItemContentWidthAtIndexPath:indexPath];
            CGSize size = CGSizeMake(width, height);
            
            UICollectionViewLayoutAttributes *arr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            arr.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
            [self.itemAttributes addObject:arr];
            
            self.rowsMaxRightArray[row] = @(CGRectGetMaxX(arr.frame) + self.itemDistance);
            origin.y = origin.y + self.lineDistance + height;
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.itemAttributes;
}

- (CGSize)collectionViewContentSize {
    CGFloat max = 0;
    for (NSNumber *n in self.rowsMaxRightArray) {
        if (n.doubleValue > max) {
            max = n.doubleValue;
        }
    }
    return CGSizeMake(max + self.sectionInset.right, self.collectionView.frame.size.height);
}

@end
