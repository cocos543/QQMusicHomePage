//
//  VipViewCell.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/17.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "VipViewCell.h"
#import "VIP1CollectionViewCell.h"

#import "UIImageView+WebCache.h"

@implementation VipViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionView registerNib:[UINib nibWithNibName:@"VIP1CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VIP1CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.listJson[indexPath.item];
    cell.titleLabel.text = dic[@"title"];
    [cell.bigImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"picurl"]]];
    for (UIImageView *v in cell.imgViewArr) {
        [v sd_setImageWithURL:[NSURL URLWithString:dic[@"singers"][0][@"picurl"]]];
    }
    for (UILabel *l in cell.itemsTitleArr) {
        l.text = dic[@"title"];
    }
    return cell;
}

@end
