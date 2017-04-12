//
//  MineViewController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "MineViewController.h"
#import "MineModel.h"
#import "MineCell.h"
#import "JMLoginController.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UITableView *setTableView;
@end

@implementation MineViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {self.dataArray = [NSMutableArray array];}
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setupTableView
{
    [self getSetArray];
    UITableView *setTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    [setTableView registerClass:[MineCell class] forCellReuseIdentifier:@"mineCell"];
    setTableView.delegate = self;
    setTableView.dataSource = self;
    setTableView.sectionHeaderHeight = 0;
    setTableView.sectionFooterHeight = 0;
    setTableView.separatorColor = JMColor(215, 215, 221);
    setTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:setTableView];
    self.setTableView = setTableView;
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sections = self.dataArray[indexPath.section];
    MineModel *model = sections[indexPath.row];
    MineCell *cell = [MineCell setCell:tableView IndexPath:indexPath model:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        JMLoginController *login = [[JMLoginController alloc] init];
        login.urlString = @"http://www.pictoshare.net/index.php?controller=simple&action=login";
        [self.tabBarController.navigationController pushViewController:login animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (void)getSetArray
{
    NSArray *kSetArray = @[
                           @[@{@"title":@"个人信息", @"icon":@"mine_32"}, @{@"title":@"账户安全", @"icon":@"safe"}],
                           @[@{@"title":@"勿扰模式", @"icon":@"more"}, @{@"title":@"清除缓存", @"icon":@"cache"}, @{@"title":@"夜晚模式", @"icon":@"night"}],
                           @[@{@"title":@"联系我们", @"icon":@"aboutus"}, @{@"title":@"退出登录", @"icon":@"logout_32"}]
                           ];
    
    for (NSArray *arr in kSetArray) {
        
        NSMutableArray *a = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            
            MineModel *model = [[MineModel alloc] init];
            model.title = dic[@"title"];
            model.icon = dic[@"icon"];
            model.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [a addObject:model];
        }
        
        [self.dataArray addObject:a];
    }
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
