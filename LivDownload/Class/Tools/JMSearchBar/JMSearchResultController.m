//
//  JMSearchResultController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/3/31.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "JMSearchResultController.h"
#import "JMSearchModel.h"

@interface JMSearchResultController ()<UITableViewDataSource, UITableViewDelegate>

@end

static NSString *const kReuseIdentifier = @"CellReuseIdentifier";
@implementation JMSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuseIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    JMSearchModel *model = self.searchResults[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *newVC = [[UIViewController alloc] init];
    JMSearchModel *model = self.searchResults[indexPath.row];
    newVC.title = model.name;
    newVC.view.backgroundColor = [UIColor lightGrayColor];
    [self.mainSearchController.navigationController pushViewController:newVC animated:YES];
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
