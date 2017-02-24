//
//  DownloadNavController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "DownloadNavController.h"
#import "NSObject+PYThemeExtension.h"
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface DownloadNavController ()<UINavigationControllerDelegate>

@end

@implementation DownloadNavController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        
        UINavigationBar *navBar = [[UINavigationBar alloc] init];
        [navBar py_addToThemeColorPool:@"barTintColor"];
        navBar.tintColor = [UIColor whiteColor];
        NSDictionary *attr = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                                };
        navBar.titleTextAttributes = attr;
        [self setValue:navBar forKey:@"navigationBar"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor = JMColor(0, 0.5, 1);
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationBar.tintColor = [UIColor colorWithWhite:1.f alpha:0.5];
    self.delegate = self;
    
}

+ (void)setupNavTheme
{
    NSDictionary *textAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:JMColor(90, 200, 93)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [super pushViewController:viewController animated:animated];
//
//
//}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//
//}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([viewController.class isSubclassOfClass:NSClassFromString(@"JMBaseViewController")] && ![viewController isKindOfClass:NSClassFromString(@"JMChatViewController")]) {
//
//        viewController.tabBarController.tabBar.hidden = NO;
//
//    }else{
//        viewController.tabBarController.tabBar.hidden = YES;
//    }
//
//    JMLog(@"%@", viewController);
//}

- (BOOL)prefersStatusBarHidden
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
