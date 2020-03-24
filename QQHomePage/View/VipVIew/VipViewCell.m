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
    cell.titleLabel.text              = dic[@"title"];
    [cell.bigImgView setImageURL:[NSURL URLWithString:dic[@"picurl"]]];
    cell.bigImgView.asyncCornerRadius = 10.f;
    cell.bigImgView.backgroundColor   = UIColor.clearColor;
    cell.bigImgView.maskColors        = @[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    cell.bigImgView.drawMask          = YES;

    for (AsyncImageView *v in cell.imgViewArr) {
        v.imageURL          = [NSURL URLWithString:dic[@"singers"][0][@"picurl"]];
        v.asyncCornerRadius = 10.f;
        v.backgroundColor   = UIColor.clearColor;
    }

    for (UILabel *l in cell.itemsTitleArr) {
        l.text = dic[@"title"];
    }
    return cell;
}

@end
