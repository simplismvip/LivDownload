//
//  JMSearchController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/3/31.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "JMSearchController.h"
#import "JMSearchView.h"
#import "UIView+Extension.h"
#import "JMSearchHistoryCell.h"

@interface JMSearchController ()<UITableViewDataSource, UITableViewDelegate, JMSearchHistoryCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

static NSString *const ID = @"cell";
@implementation JMSearchController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {self.dataSource = [NSMutableArray array];}
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    [self creatTableView];
}

- (void)creatTableView
{
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:(UITableViewStylePlain)];
    [tabView registerClass:[JMSearchHistoryCell class] forCellReuseIdentifier:ID];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.separatorColor = tabView.backgroundColor;
    self.tableView = tabView;
    [self.view addSubview:tabView];
    
    JMSearchView *view = [[JMSearchView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    tabView.tableHeaderView = view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;//self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;//[self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JMSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {cell = [[JMSearchHistoryCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.delegate = self;
    [cell setImage:@"search_32" btnImage:@"close_icon_black" content:@"搜索历史"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择 -- %@", indexPath);
}

#pragma mark -- JMSearchHistoryCellDelegate
- (void)deleteCell:(NSIndexPath *)indexPath
{
    
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
