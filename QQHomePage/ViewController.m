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

#import "SearchView.h"

#define SearchHeight 50

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LHPerformanceMonitorService run];
}

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

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

@end
