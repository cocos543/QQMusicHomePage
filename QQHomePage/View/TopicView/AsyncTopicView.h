//
//  AsyncTopicView.h
//  QQHomePage
//
//  Created by Cocos on 2020/3/18.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsyncTopicView : UIView

/// 这个label只是用来存储文本的信息, 并不会真的被展示到屏幕上
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
