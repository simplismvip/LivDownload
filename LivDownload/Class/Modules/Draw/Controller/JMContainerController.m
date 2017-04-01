//
//  JMContainerController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/3/30.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "JMContainerController.h"
#import "JMSegmentBar.h"
#import "JMGridController.h"
#import "UIView+Extension.h"
#import "NSObject+JMProperty.h"
#import "UINavigationBar+JMNavigationBar.h"
#import "ClassModel.h"
#import "UserDefaultTools.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface JMContainerController ()<UIScrollViewDelegate, JMSegmentBarDelegate>

@property (nonatomic, weak) UIScrollView *scroView;
@property (nonatomic, weak) JMSegmentBar *segmentBar;
@property (nonatomic, assign) CGFloat beginOffsetX;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign,readwrite) NSInteger currentTimes;
@end

@implementation JMContainerController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.currentTimes=0;
    self.count=0;
}

- (NSDictionary *)getDic:(NSString *)name image:(NSString *)classImage count:(NSString *)count classMembers:(NSString *)classMembers
{
    NSString *tesacher = @"讲师: OP";
    return @{@"classImage":classImage, @"className":name, @"classTime":tesacher, @"classCount":count, @"classMembers":classMembers};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubviews:0];
    [self.navigationController.navigationBar setNavigationBarLine:0.5];
}

#pragma mark -- 左右item
- (void)switchAction:(UIBarButtonItem *)rightItem
{
    JMGridController *vc = self.controllers[self.segmentBar.selectIndex];
    [vc switchGrid];
    [self setBarItem:vc.key];
}

- (void)leftItem:(UIBarButtonItem *)left
{
    JMGridController *vc = self.controllers[self.segmentBar.selectIndex];
    [vc leftSwitchStatus];
    [self setBarItem:vc.key];
}

#pragma mark -- 创建子View
- (void)creatSubviews:(NSInteger)selecIndex
{
    NSMutableArray *models0 = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        
        NSString *image = @"http://img.taopic.com/uploads/allimg/110728/6310-110HQ1491019.jpg";
        NSDictionary *dic = [self getDic:[NSString stringWithFormat:@"课堂 :%d", i] image:image count:[NSString stringWithFormat:@"人数 :%d", i] classMembers:@"none"];
        [models0 addObject:[ClassModel objectWithDictionary:dic]];
    }
    
    NSMutableArray *models1 = [NSMutableArray array];
    for (int i = 0; i < 7; i ++) {
        
        NSString *image = @"http://img.taopic.com/uploads/allimg/110728/6310-110HQ1491019.jpg";
        NSDictionary *dic = [self getDic:[NSString stringWithFormat:@"课堂 :%d", i] image:image count:[NSString stringWithFormat:@"人数 :%d", i] classMembers:@"none"];
        [models1 addObject:[ClassModel objectWithDictionary:dic]];
    }

    NSMutableArray *models2 = [NSMutableArray array];
    for (int i = 0; i < 9; i ++) {
        
        NSString *image = @"http://img.taopic.com/uploads/allimg/110728/6310-110HQ1491019.jpg";
        NSDictionary *dic = [self getDic:[NSString stringWithFormat:@"课堂 :%d", i] image:image count:[NSString stringWithFormat:@"人数 :%d", i] classMembers:@"none"];
        [models2 addObject:[ClassModel objectWithDictionary:dic]];
    }

    
    // 创建控制器
    JMGridController *class1 = [[JMGridController alloc] init];
    class1.dataSource = models0;
    class1.title = @"文档";
    class1.key = @"pub";
    
    JMGridController *class2 = [[JMGridController alloc] init];
    class2.title = @"回放";
    class2.key = @"pra";
    class2.dataSource = models1;
    
    JMGridController *class3 = [[JMGridController alloc] init];
    class3.title = @"课程";
    class3.key = @"pra";
    class3.dataSource = models2;
    
    self.controllers = [NSMutableArray arrayWithArray:@[class1, class2, class3]];
    
    UIScrollView *scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, self.view.width, self.view.height-94)];
    scroView.delegate = self;
    scroView.pagingEnabled = YES;
    scroView.contentSize = CGSizeMake(self.view.width*self.controllers.count, self.view.height-94);
    scroView.showsVerticalScrollIndicator = NO;
    scroView.showsHorizontalScrollIndicator = NO;
    scroView.bounces = NO;
    [self.view addSubview:scroView];
    self.scroView = scroView;
    
    JMSegmentBar *segmentBar = [[JMSegmentBar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 30)];
    segmentBar.delegate = self;
    segmentBar.items = self.controllers;
    segmentBar.selectIndex = 0;
    [self.view addSubview:segmentBar];
    self.segmentBar = segmentBar;
    
    NSString *tabbarName;
    if ([UserDefaultTools readBoolByKey:class1.key]) {tabbarName = @"product_list_grid_btn";
    } else {tabbarName = @"product_list_list_btn";}
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:tabbarName] style:(UIBarButtonItemStyleDone) target:self action:@selector(switchAction:)];
    self.navigationItem.rightBarButtonItem = right;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 将leftItem设置为自定义按钮
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(leftItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark -- 切换控制机器
- (void)changeController:(NSInteger)index
{
    for (JMGridController *controller in self.controllers) {
        
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    JMGridController *vc = self.controllers[index];
    vc.view.frame = CGRectMake((index)*CGRectGetWidth(self.scroView.frame), 0, CGRectGetWidth(self.scroView.frame), CGRectGetHeight(self.scroView.frame));
    
    [vc willMoveToParentViewController:self];
    [self addChildViewController:vc];
    
    [vc didMoveToParentViewController:self];
    [self.scroView addSubview:vc.view];
    
    [self setBarItem:vc.key];
    
    // 上一个
    if (index + 1 < self.controllers.count) {
        
        JMGridController *nextController = self.controllers[index + 1];
        UIView *nextView = nextController.view;
        [nextView removeFromSuperview];
        nextView.frame = CGRectMake((index + 1) * CGRectGetWidth(self.scroView.frame), 0, CGRectGetWidth(self.scroView.frame), CGRectGetHeight(self.scroView.frame));
        [self.scroView addSubview:nextView];
    }
    
    // 下一个
    if (index - 1 >= 0) {
        
        JMGridController *previousController = self.controllers[index - 1];
        UIView *previousView = previousController.view;
        [previousView removeFromSuperview];
        [self.scroView addSubview:previousView];
        previousView.frame = CGRectMake((index - 1) * CGRectGetWidth(self.scroView.frame), 0, CGRectGetWidth(self.scroView.frame), CGRectGetHeight(self.scroView.frame));
    }
    
    [self.scroView scrollRectToVisible:vc.view.frame animated:YES];
}


- (void)setBarItem:(NSString *)key
{
    if ([UserDefaultTools readBoolByKey:key]) {
        
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"product_list_grid_btn"];
        
    } else {
        
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"product_list_list_btn"];
    }
}

#pragma mark -- UIScrollViewDelegate;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!scrollView.isDecelerating) {
        
        self.beginOffsetX = CGRectGetWidth(scrollView.frame) * self.segmentBar.selectIndex;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat targetX = targetContentOffset->x;
    NSInteger selectIndex = targetX/CGRectGetWidth(self.scroView.frame);
    self.segmentBar.selectIndex = selectIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.segmentBar scrollToRate:scrollView.contentOffset.x];
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
