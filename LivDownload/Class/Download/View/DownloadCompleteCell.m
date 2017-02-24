//
//  DownloadCompleteCell.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/23.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "DownloadCompleteCell.h"
#import "UIView+Extension.h"
#import "DownloadModel.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface DownloadCompleteCell()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *header;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *sumSize;

@end

@implementation DownloadCompleteCell

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
        
        UILabel *sumSize = [[UILabel alloc] init];
        sumSize.font = [UIFont systemFontOfSize:11.0];
        sumSize.textColor = JMColor(105, 105, 105);
        sumSize.textAlignment = NSTextAlignmentCenter;
        [self addSubview:sumSize];
        self.sumSize = sumSize;
    }
    
    return self;
}

+ (instancetype)initWithDownloadCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(DownloadModel *)model
{
    static NSString *ID = @"downloadCompleteCell";
    DownloadCompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.header.image = [UIImage imageNamed:model.imagePath];
    cell.sumSize.text = model.netSpeed;
    cell.name.text = model.name;
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.width-self.height-12;
    self.header.frame = CGRectMake(10, 4, self.height-8, self.height-8);
    self.name.frame = CGRectMake(CGRectGetMaxX(_header.frame)+10, CGRectGetMinY(_header.frame), width*0.7, self.height-8);
    self.sumSize.frame = CGRectMake(CGRectGetMaxX(_name.frame), CGRectGetMinY(_header.frame), width*0.3, self.height-8);
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
