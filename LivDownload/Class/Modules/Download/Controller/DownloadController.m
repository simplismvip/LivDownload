//
//  DownloadController.m
//  DownloadTest
//
//  Created by JM Zhao on 2017/2/21.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "DownloadController.h"
#import "DownloadCell.h"
#import "DownloadCompleteCell.h"
#import "DownloadModel.h"
#import "AFNetworking.h"
#import "LivDownloadHelper.h"
#import "LivViewController.h"
#import "SegmentControl.h"
#import "JMCloudShareController.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define downloadUrl @"http://182.254.223.23/download/records/pubXXX/"
#define loadUrl @"http://server.pictolive.net:9000/play/list?format=json"
#define JMSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface DownloadController ()<UITableViewDelegate, UITableViewDataSource, DownloadCellDelegate>
{
    NSInteger number;
}

@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UITableView *rightTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *downloadArray;
@property (nonatomic, assign) BOOL isLeft;

@end

@implementation DownloadController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getLivList];
    [self creatSegmentControl];
    [self creatTableView:0];
    
    // 设置tableView位置
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_32"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItem:(UIBarButtonItem *)item
{
    UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    // 云中心
    [_alertController addAction:[UIAlertAction actionWithTitle:@"云共享" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        JMCloudShareController *cloundVC = [[JMCloudShareController alloc] init];
        cloundVC.urlString = @"http://www.pictoshare.net/index.php?controller=ucenter&action=share";
        [self.tabBarController.navigationController pushViewController:cloundVC animated:YES];
        
    }]];
    
    [_alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    [self presentViewController:_alertController animated:YES completion:nil];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource,
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isLeft) {
    
        return self.dataArray.count;
        
    }else{
        return self.downloadArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isLeft) {
        
        DownloadModel *model = self.downloadArray[indexPath.row];
        DownloadCompleteCell *cell = [DownloadCompleteCell initWithDownloadCell:tableView cellForRowAtIndexPath:indexPath model:model];
        return cell;
    }else{
        
        DownloadModel *model = self.dataArray[indexPath.row];
        DownloadCell *cell = [DownloadCell initWithCell:tableView cellForRowAtIndexPath:indexPath model:model];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isLeft) {
        
        DownloadModel *model = self.downloadArray[indexPath.row];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [path stringByAppendingPathComponent:model.name];
        LivePlaybackViewController *liv =[[LivePlaybackViewController alloc] initWithLiveFilePath:filePath];
        
//        LivViewController *liv = [[LivViewController alloc] init];
//        liv.model = model;
        [self.tabBarController.navigationController pushViewController:liv animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isLeft) {
        
        if (editingStyle ==UITableViewCellEditingStyleDelete)
        {
            [self.downloadArray removeObjectAtIndex:indexPath.row];
            [self.rightTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

// 设置可以多行删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isLeft) {
        
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

#pragma mark -- DownloadCellDelegate
- (void)startDownload:(NSIndexPath *)index isStart:(BOOL)isStart
{
    __block DownloadModel *model = self.dataArray[index.row];
    if (!model.isComplete) {
    
        DownloadCell *cell = [self.leftTableView cellForRowAtIndexPath:index];
        if (isStart) {
            
            // 下载文件
            JMSelf(ws);
            NSString *path = [NSString stringWithFormat:@"%@%@", downloadUrl, model.name];
            [LivDownloadHelper loadLIvFileWithUrl:path progress:^(CGFloat progress, CGFloat sumSize) {
                
                model.netSpeed = [NSString stringWithFormat:@"%.2f MB", sumSize];
                model.precent = [NSString stringWithFormat:@"下载进度 %.0f%%", 100*progress];
                [cell reloadCellData:model];
                
            } success:^(NSMutableArray *success) {
                
                NSData *data = success.firstObject;
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filePath = [path stringByAppendingPathComponent:model.name];
                
                if ([data writeToFile:filePath atomically:YES]) {
                    
                    // 下载完成删除cell
                    [self.dataArray removeObjectAtIndex:index.row];
                    [self.leftTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationLeft)];
                    
                    model.isComplete = YES;
                    [ws.downloadArray addObject:model];
                    NSLog(@"写入成功 %@", filePath);
                }
                
            } fail:^(NSError *fail) {
                
                NSLog(@"%@", fail);
            }];

            model.playOrPause = @"navbar_pause_icon_white";
        }else{
            model.playOrPause = @"navbar_play_icon_white";
        }
        
        [cell reloadCellData:model];
    }
}

- (void)editerCell
{
    NSLog(@"start editer");
}

#pragma mark -- 数据源
- (NSMutableArray *)downloadArray
{
    if (!_downloadArray) {self.downloadArray = [NSMutableArray array];}
    return _downloadArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {self.dataArray = [NSMutableArray array];}
    return _dataArray;
}


#pragma mark -- 创建界面UI
- (void)creatSegmentControl
{
    SegmentControl *control = [[SegmentControl alloc] initWithItems:@[@"文件列表", @"下载完成"]];
    control.selectedSegmentIndex = 0;
    [control addTarget:self action:@selector(handelSegementControlAction:)forControlEvents:(UIControlEventValueChanged)];
    self.navigationItem.titleView = control;
}

- (void)creatTableView:(NSInteger)index
{
    if (index == 0) {
        
        if (self.rightTableView) {[self.rightTableView removeFromSuperview];}
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        [tableView registerClass:[DownloadCell class] forCellReuseIdentifier:@"downloadCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.separatorColor = JMColor(215, 215, 221);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        self.leftTableView = tableView;
        self.isLeft = YES;
        
    }else if(index == 1){
        
        if (self.leftTableView) {[self.leftTableView removeFromSuperview];}
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        [tableView registerClass:[DownloadCompleteCell class] forCellReuseIdentifier:@"downloadCompleteCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.separatorColor = JMColor(215, 215, 221);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        self.rightTableView = tableView;
        self.isLeft = NO;
    }
}

#pragma mark -- segmentControl Action
- (void)handelSegementControlAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        
        [self creatTableView:0];
        NSLog(@"正在下载 --- 0");
        
    }else if(sender.selectedSegmentIndex == 1){
        
        [self creatTableView:1];
        NSLog(@"正在下载 --- 1");
    }
}

#pragma mark -- 获取LIv列表
- (void)getLivList
{
    [LivDownloadHelper loadLIvFileWithUrl:loadUrl progress:^(CGFloat progress, CGFloat sumSize) {
        
        
    } success:^(NSMutableArray *success) {
        
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:success.firstObject options:(NSJSONReadingMutableContainers) error:&error];
        
        if (!error) {
            
            NSMutableArray *data = [NSMutableArray arrayWithArray:dic[@"pubXXX"]];
            self.dataArray = [NSMutableArray array];
            for (NSString *string in data) {
                
                DownloadModel *model = [[DownloadModel alloc] init];
                model.imagePath = @"padf";
                model.name = string;
                model.precent = @"下载进度 0%";
                model.netSpeed = @"0 MB";
                model.playOrPause = @"navbar_play_icon_white";
                model.deleteBtn = @"navbar_close_icon_white";
                model.isComplete = NO;
                [self.dataArray addObject:model];
            }
        }
        
        [self.leftTableView reloadData];
        
    } fail:^(NSError *fail) {
        
        NSLog(@"%@", fail);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
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
