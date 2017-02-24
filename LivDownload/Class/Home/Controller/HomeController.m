//
//  HomeController.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "HomeController.h"
#import "UIImage+MetaImage.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageWithContentsOfFile:@"/Users/mac/Desktop/14577546764Screenshot_2014-11-13-12-16-454.jpg.png"];
    [image getPNGimageInfo];
    NSLog(@"%@", [image getPNGimageInfo]);
    
    NSLog(@"%@", NSStringFromCGSize(image.size));
    
    UIImage *ima = [image creatThumbnailFromImageSource:500];
    NSLog(@"%@", NSStringFromCGSize(ima.size));
    
    UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    [self.view addSubview:imag];
    [self.view addSubview:imag1];

    imag.image = image;
    imag1.image = ima;
    
//    UIImage *imagew = [UIImage getImageFromWindow];
    NSData *data = UIImagePNGRepresentation(ima);
    [data writeToFile:@"/Users/mac/Desktop/2014-11-13-12-16-454.png" atomically:YES];
    
    
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
