//
//  TableViewSectionModel.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/11.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "TableViewSectionModel.h"

@implementation TableViewSectionModel

+ (instancetype)sectionWithCells:(NSMutableArray<TableViewCellModel *> *)cells {
    TableViewSectionModel *model = TableViewSectionModel.new;
    model.cells = cells;
    return model;
}

@end
