//
//  MVListCell.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/16.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "MVListCell.h"
#import "UIImageView+WebCache.h"

@implementation MVListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionView registerNib:[UINib nibWithNibName:@"MVCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listJson.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.listJson[indexPath.item];
    
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:dic[@"picurl"]]];
    cell.titleLabel.text = dic[@"title"];
    [cell.iconV sd_setImageWithURL:[NSURL URLWithString:dic[@"singers"][0][@"picurl"]]];
    cell.nameLabel.text = dic[@"singers"][0][@"name"];
    return cell;
}

@end
