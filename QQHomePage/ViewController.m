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
#import "TableViewCellModel.h"
#import "SearchView.h"
#import "FunctionCell.h"

#import "TableViewSectionModel.h"

#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"

#define SearchHeight 50

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}
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
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(SearchHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SearchHeight, 0, 0, 0);
    
    // 添加qq音乐顶部的搜索框
    self.searchView = [[NSBundle.mainBundle loadNibNamed:@"SearchView" owner:nil options:nil] lastObject];
    self.searchView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SearchHeight);
    self.searchView.originY = STATUS_BAR_HEIGHT;
    [self.view addSubview:self.searchView];
    
    [self handleScrollSearchView];
    [self createCellModel];
    
    [self.tableView reloadData];
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
    [self cc_easyObserve:self.tableView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew block:^(id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {

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
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"00%@",@(i)] ofType:@"jpg"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        if (img) {
            [images addObject:img];
        }
    }
    
    bannerModel.reuseIdentifier = @"BannerCell";
    bannerModel.height = 180;
    bannerModel.refreshBlock = ^(__kindof UITableViewCell * _Nonnull cell) {
        cell.backgroundColor = UIColor.clearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell.contentView.subviews.count == 0) {
            SDCycleScrollView *view = [[SDCycleScrollView alloc] init];
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.equalTo(cell.contentView).offset(10);
                make.bottom.trailing.equalTo(cell.contentView).offset(-10);
            }];
            view.localizationImageNamesGroup = images;
            view.layer.cornerRadius = 10;
            view.layer.masksToBounds = YES;
        }
    };
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:bannerModel.reuseIdentifier];
    
    // 第二个section, 展示几个功能图标
    array = @[].mutableCopy;
    [self.sections addObject:[TableViewSectionModel sectionWithCells:array]];
    TableViewCellModel *funcCellModel = [[TableViewCellModel alloc] init];
    [array addObject:funcCellModel];
    
    funcCellModel.height = 100;
    funcCellModel.reuseIdentifier = @"FuncCell";
    funcCellModel.refreshBlock = ^(__kindof UITableViewCell * _Nonnull cell) {
        
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
    TableViewCellModel *cellModel = self.sections[indexPath.section].cells[indexPath.row];;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.reuseIdentifier forIndexPath:indexPath];
    cellModel.refreshBlock(cell);
    return cell;
}

@end
