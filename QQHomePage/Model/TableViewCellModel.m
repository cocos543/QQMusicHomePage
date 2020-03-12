//
//  TableViewCellModel.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/11.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "TableViewCellModel.h"

@implementation TableViewCellModel

+ (instancetype)cellWithFreshUI:(RefreshUI)refreshBlock {
    TableViewCellModel *model = TableViewCellModel.new;
    model.refreshBlock = refreshBlock;
    return model;
}

@end
