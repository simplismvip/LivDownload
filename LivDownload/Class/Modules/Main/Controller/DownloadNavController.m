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
    
}


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
