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
#import "JMSearchModel.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface HomeController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) JMSearchResultController *resultVC;
@property (nonatomic, strong) UISearchController *searchVC;
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
    UITableView *homeTabView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    [homeTabView registerClass:[JMHomeCell class] forCellReuseIdentifier:ID];
    homeTabView.delegate = self;
    homeTabView.dataSource = self;
    homeTabView.sectionHeaderHeight = 0;
    homeTabView.sectionFooterHeight = 0;
    homeTabView.separatorColor = homeTabView.backgroundColor;
    
    [self.view addSubview:homeTabView];
    
    if ([homeTabView respondsToSelector:@selector(setSectionIndexColor:)]) {
        
        homeTabView.sectionIndexBackgroundColor = [UIColor clearColor];
        homeTabView.sectionIndexColor = [UIColor grayColor];
    }
    
    // 创建两个属性实例, 初始化搜索框
    self.resultVC = [JMSearchResultController new];
    self.resultVC.mainSearchController = self;
    
    self.searchVC= [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
    
    // 设置与界面有关的样式
    [self.searchVC.searchBar sizeToFit];
    homeTabView.tableHeaderView = self.searchVC.searchBar;
    
    // 设置搜索控制器的结果更新代理对象
    self.searchVC.searchResultsUpdater = self;
    self.searchVC.searchBar.delegate = self;
    self.definesPresentationContext = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 10;//self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;//[self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JMHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择 -- %@", indexPath);
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // 获取scope被选中的下标
    NSInteger selectedType = searchController.searchBar.selectedScopeButtonIndex;
    
    // 获取到用户输入的数据
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResult = [[NSMutableArray alloc]init];
    for (JMSearchModel *model in self.dataSource) {
        
        NSRange range=[model.name rangeOfString:searchText];
        
        if (range.length>0 && model.type == selectedType) {
            
            [searchResult addObject:model];
        }
    }
    
    self.resultVC.searchResults = searchResult;
    [self.resultVC.tableView reloadData];
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
