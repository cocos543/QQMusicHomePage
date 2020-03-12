//
//  TableViewCellModel.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/11.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshUI)(__kindof UITableViewCell *cell);

/// 包括了Cell高度, 复用的identifier, 被点击时分配的方法名等cell必备信息
@interface TableViewCellModel : NSObject

@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSString *selDidSelectedName;

@property (nonatomic, copy) RefreshUI refreshBlock;

+ (instancetype)cellWithFreshUI:(RefreshUI)refreshBlock;


@end

NS_ASSUME_NONNULL_END
