//
//  TableViewSectionModel.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/11.
//  Copyright © 2020 Cocos. All rights reserved.
//


#import "TableViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 包括了section的高度, footer, header的高度, 还有section里的cells
@interface TableViewSectionModel : NSObject

+ (instancetype)sectionWithCells:(NSMutableArray<TableViewCellModel *> *)cells;

@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) NSMutableArray<TableViewCellModel *> *cells;

@end

NS_ASSUME_NONNULL_END
