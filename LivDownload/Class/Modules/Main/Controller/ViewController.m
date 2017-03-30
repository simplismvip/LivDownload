//
//  ViewController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/21.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "ViewController.h"
#import "DownloadController.h"
#import "HomeController.h"
#import "MineViewController.h"
#import "DownloadNavController.h"
#import "JMContainerController.h"
#import "DownloadTabbar.h"
#import "UIImage+JMImage.h"
#import "NSObject+PYThemeExtension.h"
#define baseTag 120

@interface ViewController ()
@property (nonatomic, strong) HomeController *homeVC;
@property (nonatomic, strong) JMContainerController *containerVC;
@property (nonatomic, strong) DownloadController *downloadVC;
@property (nonatomic, strong) MineViewController *mineVC;
@property (nonatomic, assign) BOOL isBool;
@end

@implementation ViewController

// 测试push
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildViewController];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    backView.backgroundColor = [UIColor blueColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    
    DownloadTabbar *tabBar = [[DownloadTabbar alloc] initWithFrame:self.tabBar.frame];
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

- (void)setupChildViewController
{
    // LIv
    HomeController *homeVC = [[HomeController alloc] init];
    _homeVC = homeVC;
    [self setupChildViewController:homeVC
                             image:[UIImage imageWithRenderingName:@"tabbar_mainframe"]
                          selImage:[[UIImage imageNamed:@"tabbar_mainframeHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                             title:@"Liv"
                               tag:baseTag+0];
    
    // LIv
    JMContainerController *containerVC = [[JMContainerController alloc] init];
    _containerVC = containerVC;
    [self setupChildViewController:containerVC
                             image:[UIImage imageWithRenderingName:@"tabbar_contacts"]
                          selImage:[[UIImage imageNamed:@"tabbar_contactsHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                             title:@"文档"
                               tag:baseTag+0];
    
    
    // 下载
    DownloadController *downloadVC = [[DownloadController alloc] init];
    _downloadVC = downloadVC;
    [self setupChildViewController:downloadVC
                             image:[UIImage imageWithRenderingName:@"tabbar_discover"]
                          selImage:[[UIImage imageNamed:@"tabbar_discoverHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                             title:@"下载"
                               tag:baseTag+1];
    
    // 设置
    MineViewController *mineVC = [[MineViewController alloc] init];
    _mineVC = mineVC;
    [self setupChildViewController:mineVC
                             image:[UIImage imageWithRenderingName:@"tabbar_me"]
                          selImage:[[UIImage imageNamed:@"tabbar_meHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                             title:@"设置"
                               tag:baseTag+3];
}

#pragma mark - 设置tabBar抽取方法
- (void)setupChildViewController:(UIViewController *)vc image:(UIImage *)image selImage:(UIImage *)selImage title:(NSString *)title tag:(NSInteger)tag
{
    vc.tabBarItem.tag = tag;
    vc.title = title;
    
    NSMutableDictionary *attrNol = [NSMutableDictionary dictionary];
    attrNol[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [vc.tabBarItem setTitleTextAttributes:attrNol forState:UIControlStateNormal];
    NSMutableDictionary *attrSel = [NSMutableDictionary dictionary];
    attrSel[NSForegroundColorAttributeName] = @"PYTHEME_THEME_COLOR";
    [vc.tabBarItem py_addToThemeColorPoolWithSelector:@selector(setTitleTextAttributes:forState:) objects:@[attrSel, @(UIControlStateSelected)]];
  
    [vc.tabBarItem setImage:image];
    [vc.tabBarItem setSelectedImage:selImage];
    
    DownloadNavController *nav = [[DownloadNavController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
