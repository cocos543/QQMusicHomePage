//
//  ViewController.m
//  QQHomePage
//
//  Created by Cocos on 2020/3/11.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "ViewController.h"
#import "LHPerformanceMonitorService.h"
#import "NSObject+CCEasyKVO.h"
#import "TableViewSectionModel.h"

#import "SearchView.h"
#import "FunctionCell.h"
#import "NewSongView.h"
#import "TopicViewCell.h"
#import "SongListCell.h"
#import "MVListCell.h"
#import "VipViewCell.h"

#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "JsonLoader.h"
#import "AsyncImageView.h"

#define SearchHeight 55

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<TableViewSectionModel *> *sections;

// 顶部搜索视图
@property (nonatomic, strong) SearchView *searchView;

@property (nonatomic, strong) UIWindow *w;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    
    self.tableView.contentInset = UIEdgeInsetsMake(SearchHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SearchHeight, 0, 0, 0);

    // 添加qq音乐顶部的搜索框
    self.searchView         = [[NSBundle.mainBundle loadNibNamed:@"SearchView" owner:nil options:nil] lastObject];
    self.searchView.frame   = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SearchHeight);
    self.searchView.originY = STATUS_BAR_HEIGHT;
    [self.view addSubview:self.searchView];

    [self handleScrollSearchView];
    [self createCellModel];

    [self.tableView reloadData];
    
//    AsyncImageView *view = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 50, 150, 150)];
//    view.asyncCornerRadius = 25;
//    view.imageURL = [NSURL URLWithString:@"http://p.qpic.cn/music_cover/1kicVrMEg0Fn1TyQ2yOZs3ZTp9gyvcRfy9QkvwLicuJIa2E5jGCyibiazA/600?n=1"];
//    [self.view addSubview:view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LHPerformanceMonitorService run];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDarkContent;
}

#pragma mark - SearchView animation
- (void)handleScrollSearchView {
    __weak typeof(self) weakSelf = self;
    [self cc_easyObserve:self.tableView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew block:^(id _Nonnull object, NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        // 获取tv滚动的距离, 如果dist为负数, 说明页面向下拉
        CGFloat dist = offset.y - (-weakSelf.tableView.contentInset.top);

        // dist加上searchView.originY, 就是searView需要安放的位置.
        if (offset.y < -weakSelf.tableView.contentInset.top) {
            CGRect frame = self.searchView.frame;
            frame.origin.y = self.searchView.originY;
            weakSelf.searchView.frame = frame;
            return;
        }

        CGRect frame = weakSelf.searchView.frame;
        // dist大于0时, 说明页面上拉了一段距离, 所以searchView对应向上移动
        frame.origin.y = -dist + weakSelf.searchView.originY;
        weakSelf.searchView.frame = frame;
    }];
}

#pragma Cell Model
- (NSMutableArray *)createNewCellModelInSections:(NSMutableArray *)sections {
    return sections;
}

- (void)createCellModel {
    self.sections = @[].mutableCopy;

    NSMutableArray *array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    // 第一个Section包含了一个banner视图
    TableViewCellModel *bannerModel = [[TableViewCellModel alloc] init];
    [array addObject:bannerModel];
    // Banner几张图
    NSMutableArray *images = @[].mutableCopy;
    // 简单加载一下本地几张图
    for (int i = 1; i <= 4; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"00%@", @(i)] ofType:@"jpg"];
        UIImage *img   = [UIImage imageWithContentsOfFile:path];
        if (img) {
            [images addObject:img];
        }
    }

    bannerModel.reuseIdentifier = @"BannerCell";
    bannerModel.height = 170;
    bannerModel.refreshBlock    = ^(__kindof UITableViewCell *_Nonnull cell) {
        cell.backgroundColor = UIColor.clearColor;
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        if (cell.contentView.subviews.count == 0) {
            SDCycleScrollView *view = [[SDCycleScrollView alloc] init];
            view.autoScroll = NO;
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.equalTo(cell.contentView).offset(10);
                make.bottom.trailing.equalTo(cell.contentView).offset(-10);
            }];
            view.localizationImageNamesGroup = images;
            view.layer.cornerRadius = 10;
            view.layer.masksToBounds         = YES;
        }
    };
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:bannerModel.reuseIdentifier];

    // 第二个section, 展示几个功能图标
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    TableViewCellModel *funcCellModel = [[TableViewCellModel alloc] init];
    [array addObject:funcCellModel];

    funcCellModel.height          = 75;
    funcCellModel.reuseIdentifier = @"FuncCell";
    funcCellModel.refreshBlock    = ^(__kindof FunctionCell *_Nonnull cell) {
        cell.backgroundColor = UIColor.clearColor;
    };
    [self.tableView registerClass:FunctionCell.class forCellReuseIdentifier:funcCellModel.reuseIdentifier];

    // 第三个section比较简单, 就固定两个长得一样的View
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    TableViewCellModel *newSongCellModel = [[TableViewCellModel alloc] init];
    [array addObject:newSongCellModel];
    newSongCellModel.height          = 60;
    newSongCellModel.reuseIdentifier = @"NewSongCell";
    newSongCellModel.refreshBlock    = ^(__kindof UITableViewCell *_Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.clearColor;
        if (cell.contentView.subviews.count == 0) {
            // 创建两个可点击的视图
            NewSongView *songView1 = [NSBundle.mainBundle loadNibNamed:@"NewSongView" owner:nil options:nil].lastObject;
            NewSongView *songView2 = [NSBundle.mainBundle loadNibNamed:@"NewSongView" owner:nil options:nil].lastObject;
            
            [cell.contentView addSubview:songView1];
            [cell.contentView addSubview:songView2];
            
            [songView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(@20);
                make.top.bottom.equalTo(cell.contentView);
            }];
            [songView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(@-20);
                make.top.bottom.equalTo(cell.contentView);
            }];
            [songView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(songView2.mas_leading).offset(-8);
                make.width.equalTo(songView2);
            }];
            
            // 临时加载图片
            songView1.imgV.image = [UIImage imageNamed:@"song1.jpg"];
            songView1.titleLabel.text = @"新歌新碟";
            songView1.subTitleLabel.text = @"Dvwn超i性感合作曲";
            
            songView2.imgV.image = [UIImage imageNamed:@"song2.jpg"];
            songView2.titleLabel.text = @"数字专辑·票务";
            songView2.subTitleLabel.text = @"绝色坤学长";
            
        }
    };
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:newSongCellModel.reuseIdentifier];
    
    // 第4个section, 由一个横向流式布局的collection view组成
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    TableViewCellModel *topicsCellModel = [[TableViewCellModel alloc] init];
    [array addObject:topicsCellModel];
    topicsCellModel.height = 85;
    topicsCellModel.reuseIdentifier = @"TopicsCell";
    [self.tableView registerClass:TopicViewCell.class forCellReuseIdentifier:topicsCellModel.reuseIdentifier];
    topicsCellModel.refreshBlock = ^(__kindof UITableViewCell * _Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.clearColor;
    };
    
    // 第5个section, 由一个横向collection view组成, 其中每个cell由多个图片叠加而成
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    // 官方歌单, 歌单有两种高度, 单行标题是201, 双行标题221
    TableViewCellModel *officialSongListModel = [[TableViewCellModel alloc] init];
    [array addObject:officialSongListModel];
    officialSongListModel.height = 211;
    officialSongListModel.reuseIdentifier = @"SongListCell";
    [self.tableView registerNib:[UINib nibWithNibName:@"SongListCell" bundle:nil] forCellReuseIdentifier:officialSongListModel.reuseIdentifier];
    NSArray *json = [JsonLoader jsonObjsWithFileName:@"songlist166.json"];
    officialSongListModel.refreshBlock = ^(__kindof SongListCell * _Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"官方歌单";
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)cell.collectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(115, 160);
        cell.listJson = json;
    };
    
    // 第6个section, 旅行歌单, 长得和第5个是一样的, 偷懒一下直接把代码抄过来就可以了
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    // 官方歌单, 歌单有两种高度, 单行标题是201, 双行标题221
    TableViewCellModel *travelSongListModel = [[TableViewCellModel alloc] init];
    [array addObject:travelSongListModel];
    travelSongListModel.height = 211;
    travelSongListModel.reuseIdentifier = @"SongListCell";
    [self.tableView registerNib:[UINib nibWithNibName:@"SongListCell" bundle:nil] forCellReuseIdentifier:officialSongListModel.reuseIdentifier];
    NSArray *travelJson = [JsonLoader jsonObjsWithFileName:@"songlist81.json"];
    travelSongListModel.refreshBlock = ^(__kindof SongListCell * _Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"旅行歌单";
        [cell updateItemSize:CGSizeMake(115, 160)];
        cell.listJson = travelJson;
        [cell.collectionView reloadData];
    };
    
    // 第7个section, 视频专区, 同样是一个横向滚动的collection view, 不过他的cell是一个矩形
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    // 官方歌单, 歌单有两种高度, 单行标题是201, 双行标题221
    TableViewCellModel *mvListModel = [[TableViewCellModel alloc] init];
    [array addObject:mvListModel];
    mvListModel.height = 231;
    mvListModel.reuseIdentifier = @"MVListCell";
    [self.tableView registerNib:[UINib nibWithNibName:@"MVListCell" bundle:nil] forCellReuseIdentifier:mvListModel.reuseIdentifier];
    NSArray *mvJson = [JsonLoader jsonObjsWithFileName:@"mvlist11.json"];
    mvListModel.refreshBlock = ^(__kindof MVListCell * _Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"歌手专区";
        [cell updateItemSize:CGSizeMake(230, 160)];
        cell.listJson = mvJson;
        [cell.collectionView reloadData];
    };
    
    // 第8个section, 继续一个歌单
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    // 官方歌单, 歌单有两种高度, 单行标题是201, 双行标题221
    TableViewCellModel *studySongListModel = [[TableViewCellModel alloc] init];
    [array addObject:studySongListModel];
    studySongListModel.height = 211;
    studySongListModel.reuseIdentifier = @"SongListCell";
    NSArray *studyJson = [JsonLoader jsonObjsWithFileName:@"songlist101.json"];
    studySongListModel.refreshBlock = ^(__kindof SongListCell * _Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"学习歌单";
        [cell updateItemSize:CGSizeMake(115, 160)];
        cell.listJson = studyJson;
        [cell.collectionView reloadData];
    };
    
    // 第9个section, 视频专区
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    // 官方歌单, 歌单有两种高度, 单行标题是201, 双行标题221
    TableViewCellModel *mv12ListModel = [[TableViewCellModel alloc] init];
    [array addObject:mv12ListModel];
    mv12ListModel.height = 231;
    mv12ListModel.reuseIdentifier = @"MVListCell";
    NSArray *mv12Json = [JsonLoader jsonObjsWithFileName:@"mvlist12.json"];
    mv12ListModel.refreshBlock = ^(__kindof MVListCell * _Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"影视专区";
        [cell updateItemSize:CGSizeMake(230, 160)];
        cell.listJson = mv12Json;
        [cell.collectionView reloadData];
    };
    
    // 第10 个section, 歌单
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    // 官方歌单, 歌单有两种高度, 单行标题是201, 双行标题221
    TableViewCellModel *schoolSongListModel = [[TableViewCellModel alloc] init];
    [array addObject:schoolSongListModel];
    schoolSongListModel.height = 211;
    schoolSongListModel.reuseIdentifier = @"SongListCell";
    NSArray *schoolJson = [JsonLoader jsonObjsWithFileName:@"songlist16.json"];
    schoolSongListModel.refreshBlock = ^(__kindof SongListCell * _Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"校园歌单";
        [cell updateItemSize:CGSizeMake(115, 160)];
        cell.listJson = schoolJson;
        [cell.collectionView reloadData];
    };
    
    // 第11个section, VIP专区
    array = @[].mutableCopy;
    TableViewSectionModel *vipSec = [TableViewSectionModel sectionWithCells:array];
    vipSec.footerHeight = 20;
    [self.sections addObject:vipSec];
    // 官方歌单, 歌单有两种高度, 单行标题是201, 双行标题221
    TableViewCellModel *vipModel = [[TableViewCellModel alloc] init];
    [array addObject:vipModel];
    vipModel.height = 271;
    vipModel.reuseIdentifier = @"VIPCell";
    NSArray *vipJson = [JsonLoader jsonObjsWithFileName:@"viplist.json"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VipViewCell" bundle:nil] forCellReuseIdentifier:vipModel.reuseIdentifier];
    
    vipModel.refreshBlock = ^(__kindof SongListCell * _Nonnull cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"VIP专区";
        [cell updateItemSize:CGSizeMake(360, 220)];
        cell.listJson = vipJson;
        [cell.collectionView reloadData];
    };
    
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCellModel *cellModel = self.sections[indexPath.section].cells[indexPath.row];
    return cellModel.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections[section].cells.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sections[section].headerHeight + 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.sections[section].footerHeight + 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCellModel *cellModel = self.sections[indexPath.section].cells[indexPath.row];

    UITableViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:cellModel.reuseIdentifier forIndexPath:indexPath];
    cellModel.refreshBlock(cell);
    return cell;
}

@end
