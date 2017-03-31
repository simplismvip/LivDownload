//
//  JMDrawController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/3/30.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "JMDrawController.h"
#import "JMTopTableView.h"
#import "JMBottomCell.h"
#import "JMBottomView.h"
#import "JMTopBarModel.h"
#import "JMBottomModel.h"

@interface JMDrawController ()<JMTopTableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JMDrawController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = @[@"返回", @"画笔", @"擦除", @"录音", @"视频", @"播放", @"暂停"];
    for (NSString *string in array) {
        
        JMTopBarModel *model = [[JMTopBarModel alloc] init];
        model.title = string;
        model.column = 1;
        NSMutableArray *bModels = [NSMutableArray array];
        NSInteger number = 3+arc4random()%4;
        
        for (int j = 0; j < number; j ++) {
            
            JMBottomModel *bModel = [[JMBottomModel alloc] init];
            bModel.title = @"直线";
            bModel.isSelect = NO;
            bModel.image = @"more";
            [bModels addObject:bModel];
        }
        
        model.models = [bModels copy];
        [self.dataSource addObject:model];
    }
    
    JMTopTableView *topbar = [[JMTopTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    topbar.dataSource = self.dataSource;
    topbar.delegate = self;
    [self.view addSubview:topbar];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {self.dataSource = [NSMutableArray array];}
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)topTableView:(JMBottomType)bottomType didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)topTableViewDisSelectSection:(NSInteger)section
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
