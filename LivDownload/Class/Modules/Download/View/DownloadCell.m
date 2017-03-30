//
//  DownloadCell.m
//  DownloadTest
//
//  Created by JM Zhao on 2017/2/21.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "DownloadCell.h"
#import "UIView+Extension.h"
#import "DownloadModel.h"
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface DownloadCell()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *header;
@property (nonatomic, weak) UIButton *playAndPause;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, assign) BOOL isPlay;

@end

@implementation DownloadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 左侧label
        UIImageView *image = [[UIImageView alloc] init];
        [self addSubview:image];
        self.header = image;
        
        // 右侧label
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:13.0];
        name.textColor = JMColor(55, 55, 55);
        name.textAlignment = NSTextAlignmentLeft;
        [self addSubview:name];
        self.name = name;
        
        UILabel *precent = [[UILabel alloc] init];
        precent.font = [UIFont systemFontOfSize:11.0];
        precent.textColor = JMColor(105, 105, 105);
        precent.textAlignment = NSTextAlignmentLeft;
        [self addSubview:precent];
        self.precent = precent;
        
        UILabel *netSpeed = [[UILabel alloc] init];
        netSpeed.font = [UIFont systemFontOfSize:11.0];
        netSpeed.textColor = JMColor(105, 105, 105);
        netSpeed.textAlignment = NSTextAlignmentCenter;
        [self addSubview:netSpeed];
        self.netSpeed = netSpeed;
        
        // 右侧label
        UIButton *play = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [play setTintColor:JMColor(145, 145, 145)];
        [play addTarget:self action:@selector(playAndPause:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:play];
        self.playAndPause = play;
    }
    
    return self;
}

- (void)playAndPause:(UIButton *)btn event:(id)event
{
    UITouch *touch =[[event allTouches] anyObject];
    NSIndexPath *indexpath = [_tableView indexPathForRowAtPoint:[touch locationInView:_tableView]];
    if (indexpath) {
        
        if ([self.delegate respondsToSelector:@selector(startDownload:isStart:)]) {
            
            self.isPlay = !self.isPlay;
            [self.delegate startDownload:indexpath isStart:self.isPlay];
        }
    }
}

+ (instancetype)initWithCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(DownloadModel *)model
{
    static NSString *ID = @"downloadCell";
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tableView = tableView;
    cell.header.image = [UIImage imageNamed:model.imagePath];
    cell.precent.text = model.precent;
    cell.netSpeed.text = model.netSpeed;
    cell.name.text = model.name;
    [cell.playAndPause setImage:[UIImage imageNamed:model.playOrPause] forState:(UIControlStateNormal)];
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.header.frame = CGRectMake(10, 4, self.height-8, self.height-8);
    self.name.frame = CGRectMake(CGRectGetMaxX(_header.frame)+10, CGRectGetMinY(_header.frame), self.width*0.5, self.height/2-2);
    self.precent.frame = CGRectMake(CGRectGetMinX(_name.frame), CGRectGetMaxY(_name.frame), CGRectGetWidth(_name.frame), self.height/2-2);
    self.playAndPause.frame = CGRectMake(self.width-self.height, CGRectGetMinY(_header.frame), self.height-10, self.height-10);
    self.netSpeed.frame = CGRectMake(CGRectGetMaxX(_precent.frame), self.height/2, CGRectGetMinX(_playAndPause.frame)-CGRectGetMaxX(_precent.frame), CGRectGetHeight(_precent.frame));
    
}

- (void)reloadCellData:(DownloadModel *)datas
{
    self.precent.text = datas.precent;
    self.netSpeed.text = datas.netSpeed;
    [self.playAndPause setImage:[UIImage imageNamed:datas.playOrPause] forState:(UIControlStateNormal)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
