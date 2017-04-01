//
//  HomeController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "HomeController.h"
#import "UIImage+MetaImage.h"
#import "JMHomeCell.h"
#import "JMHomeModel.h"
#import "JMSearchResultController.h"
#import "JMSearchController.h"
#import "JMSearchModel.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface HomeController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) JMSearchResultController *resultVC;
@property (nonatomic, strong) JMSearchController *searchVC;
@end

static NSString *const ID = @"homeCell";
@implementation HomeController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {self.dataSource = [NSMutableArray array];}
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTableView];
}

- (void)creatTableView
{
    NSArray *array = @[@"apple", @"public_1", @"class_1", @"room_1", @"class_2", @"apple_1", @"class_3", @"pub_class", @"pub_Room", @"roomNumber"];
    
    for (NSString *string in array) {
        
        JMSearchModel *model = [JMSearchModel new];
        model.name = string;
        model.type = 0;
        [self.dataSource addObject:model];
    }
    
    UITableView *homeTabView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    [homeTabView registerClass:[JMHomeCell class] forCellReuseIdentifier:ID];
    homeTabView.delegate = self;
    homeTabView.dataSource = self;
    homeTabView.sectionHeaderHeight = 0;
    homeTabView.sectionFooterHeight = 0;
    homeTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // homeTabView.separatorColor = homeTabView.backgroundColor;
    
    [self.view addSubview:homeTabView];
    
    if ([homeTabView respondsToSelector:@selector(setSectionIndexColor:)]) {
        
        homeTabView.sectionIndexBackgroundColor = [UIColor clearColor];
        homeTabView.sectionIndexColor = [UIColor grayColor];
    }
    
    // 创建两个属性实例, 初始化搜索框
    self.resultVC = [JMSearchResultController new];
    self.resultVC.mainSearchController = self;
    self.searchVC = [[JMSearchController alloc] initWithSearchResultsController:self.resultVC];
    homeTabView.tableHeaderView = self.searchVC.searchBar;
    
    // 设置搜索控制器的结果更新代理对象
    self.searchVC.searchResultsUpdater = self;
    self.searchVC.searchBar.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JMHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    JMSearchModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择 -- %@", indexPath);
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResult = [NSMutableArray array];
    
    for (JMSearchModel *model in self.dataSource) {
        
        NSRange range = [[model.name lowercaseString] rangeOfString:[searchText lowercaseString]];
        
        if (range.length > 0) {
            
            [searchResult addObject:model];
        }
    }

    self.resultVC.searchResults = searchResult;
    [self.resultVC.tableView reloadData];
    
    if (searchText.length > 0) {
        
        [self.searchVC.tableView setHidden:YES];
    }else{
        
        [self.searchVC.tableView setHidden:NO];
        [self.searchVC.tableView reloadData];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
