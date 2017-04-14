//
//  JMCloudShareController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/4/12.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "JMCloudShareController.h"
#define url @"http://www.baidu.com"

@interface JMCloudShareController ()
@end

@implementation JMCloudShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestStr = [[request.URL absoluteString] stringByRemovingPercentEncoding];
    NSLog(@"%@", requestStr);
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
