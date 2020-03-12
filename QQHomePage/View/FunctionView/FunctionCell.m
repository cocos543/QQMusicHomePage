//
//  FunctionCell.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/12.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "FunctionCell.h"
#import "FunctionCollectionCell.h"

@interface FunctionCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *icons;

@end

@implementation FunctionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        /// 这个cell比较简单, 里面就一个collection即可
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(60, 70);
        layout.minimumLineSpacing = (SCREEN_WIDTH - 40 - layout.itemSize.width*self.titles.count) / 4;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: layout];
        self.collectionView.backgroundColor = UIColor.clearColor;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"FunctionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        
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

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"歌手", @"排行", @"分类歌单", @"电台", @"一起听"];
    }
    return _titles;
}

- (NSArray *)icons {
    if (!_icons) {
        NSMutableArray *images = @[].mutableCopy;
        for (int i = 1; i <= self.titles.count; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"icon00%@", @(i)]];
            [images addObject:img];
        }
        _icons = images.copy;
    }
    return _icons;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FunctionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.item];
    cell.icon.image = self.icons[indexPath.item];
    return cell;
}

@end
