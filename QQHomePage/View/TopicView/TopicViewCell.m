//
//  TopicViewCell.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "TopicViewCell.h"
#import "TopicCollectionViewCell.h"
#import "TopicWalterfallFlowLayout.h"

@interface TopicViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, TopicWalterfallFlowLayoutDataSource>

@property (nonatomic, strong) NSArray *topics;

/// 缓存标题尺寸
@property (nonatomic, strong) NSMutableArray<NSValue *> *topicsSize;

@property (nonatomic, strong) UIFont *titleFont;

@end

@implementation TopicViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleFont = [UIFont systemFontOfSize:13];
        /// 这个cell比较简单, 里面就一个collection即可
        TopicWalterfallFlowLayout *layout = [[TopicWalterfallFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(150, 25);
        layout.sectionInset = UIEdgeInsetsMake(15, 20, 5, 20);
        layout.minimumInteritemSpacing = 0;
        layout.dataSource = self;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: layout];
        self.collectionView.backgroundColor = UIColor.clearColor;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:TopicCollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
        
        // 这里还是用自动布局
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(0);
            make.trailing.equalTo(self.contentView).offset(0);
            make.top.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (NSArray *)topics {
    if (!_topics) {
        _topics = @[@"#比伯热单舞蹈版MV", @"#白石麻衣毕业啦!", @"#NBA宣布停赛", @"#汗克斯夫妇感染新冠肺炎", @"#CA妈全球首演花木兰新歌", @"#RADWIMPS新歌MV公开", @"#BIGBANG与YG再续约", @"#IFPI公布2019单曲年榜", @"#黑寡妇终极预告", @"#Travis最新动画短片(^_^)", @"#跟着啪姐动起来", @"#j绝美的ITZY回来啦!"];
    }
    return _topics;
}

- (NSMutableArray<NSValue *> *)topicsSize {
    if (!_topicsSize) {
        _topicsSize = @[].mutableCopy;
    }
    return _topicsSize;
}

#pragma mark - TopicWalterfallFlowLayoutDataSource

- (NSInteger)topicWalterFallItemRowNumber {
    return 2;
}

- (CGFloat)topicWalterFallItemContentWidthAtIndexPath:(NSIndexPath *)indexPath {
    if (self.topicsSize.count >= indexPath.item + 1) {
        return self.topicsSize[indexPath.item].CGSizeValue.width;
    }
    CGSize size = [self.topics[indexPath.item] sizeWithAttributes:@{NSFontAttributeName: self.titleFont}];
    [self.topicsSize addObject:[NSValue valueWithCGSize:size]];
    return size.width + 15;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.topics.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.topics[indexPath.item];
    cell.titleLabel.font = self.titleFont;
    return cell;
}

@end
