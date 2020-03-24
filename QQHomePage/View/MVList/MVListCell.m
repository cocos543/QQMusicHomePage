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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.listJson[indexPath.item];
    
    [cell.imgV setImageURL:[NSURL URLWithString:dic[@"picurl"]]];
    cell.imgV.asyncCornerRadius = 10.f;
    cell.imgV.drawMask = YES;
    
    cell.titleLabel.text = dic[@"title"];
    [cell.iconV setImageURL:[NSURL URLWithString:dic[@"singers"][0][@"picurl"]]];
    cell.iconV.asyncCornerRadius = cell.iconV.frame.size.width / 2;
    cell.nameLabel.text = dic[@"singers"][0][@"name"];
    return cell;
}

@end
