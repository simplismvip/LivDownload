//
//  JMDownLoadController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/4/12.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "JMDownLoadController.h"
// http://www.pictoshare.net/index.php?controller=ucenter&action=share_download&id=2096
@interface JMDownLoadController ()

@end

@implementation JMDownLoadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
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
