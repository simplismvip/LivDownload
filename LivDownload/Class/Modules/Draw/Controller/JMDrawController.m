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
#import "JMTextView.h"
#import "JMGestureButton.h"
#import "JMTextNoteView.h"
#import "OPColorPickerView.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define JMColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define JMRandomColor JMColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface JMDrawController ()<JMTopTableViewDelegate, OPColorPickerViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JMDrawController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = @[@{@"返回":@[@"0"]}, @{@"画笔":@[]}, @{@"擦除":@[]}, @{@"录音":@[]}, @{@"播放":@[]}, @{@"表情":@[],}, @{@"颜色":@[@"0", @"0", @"0", @"0", @"0", @"0"]}, @{@"宽度":@[@"point_01", @"point_02", @"point_03", @"point_04", @"point_05", @"point_06", @"point_07"]}];
    
    for (NSDictionary *string in array) {
        
        JMTopBarModel *model = [[JMTopBarModel alloc] init];
        model.title = string.allKeys.lastObject;
        model.column = 1;
        
        NSMutableArray *bModels = [NSMutableArray array];
        
        if ([model.title isEqualToString:@"颜色"]) {
            
            for (NSString *image in string.allValues.lastObject) {
                
                JMBottomModel *bModel = [[JMBottomModel alloc] init];
                bModel.isSelect = NO;
                bModel.title = image;
                bModel.color = JMRandomColor;
                [bModels addObject:bModel];
            }
            
        }else if ([model.title isEqualToString:@"宽度"]){
        
            for (NSString *image in string.allValues.lastObject) {
                
                JMBottomModel *bModel = [[JMBottomModel alloc] init];
                bModel.title = image;
                bModel.isSelect = NO;
                bModel.image = image;
                [bModels addObject:bModel];
            }
            
        }else{
        
            NSInteger number = 3+arc4random()%4;
            for (int j = 0; j < number; j ++) {
                
                JMBottomModel *bModel = [[JMBottomModel alloc] init];
                bModel.title = @"直线";
                bModel.isSelect = NO;
                bModel.image = @"more";
                [bModels addObject:bModel];
            }
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
    [OPColorPickerView colorPickerWithColor:[UIColor redColor] delegate:self];
    
//    JMTextNoteView *textView = [[JMTextNoteView alloc] initWithFrame:CGRectMake(100, 100, 60, 20)];
//    [self.view addSubview:textView];
}

#pragma mark -- OPColorPickerViewDelegate
- (void)colorPickerViewController:(OPColorPickerView *)colorPicker didSelectColor:(UIColor *)color selectWidth:(CGFloat)width
{
    NSLog(@"%@--%@--%f", color, colorPicker, width);
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
