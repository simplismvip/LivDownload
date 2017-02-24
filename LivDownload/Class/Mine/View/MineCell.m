//
//  MineCell.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "MineCell.h"
#import "MineModel.h"
#import "UIView+Extension.h"
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface MineCell()
@property (nonatomic, weak) UIImageView *leftImage;
@property (nonatomic, weak) UILabel *textTitle;
@end

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *leftImage = [[UIImageView alloc] init];
        [leftImage setTintColor:JMColor(125, 125, 125)];
        [self.contentView addSubview:leftImage];
        self.leftImage = leftImage;
        
        UILabel *textTitle = [[UILabel alloc] init];
        textTitle.textAlignment = NSTextAlignmentLeft;
        textTitle.font = [UIFont systemFontOfSize:14.0];
        textTitle.textColor = JMColor(55, 55, 55);
        [self.contentView addSubview:textTitle];
        self.textTitle = textTitle;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _leftImage.frame = CGRectMake(10, 12, self.height-20, self.height-20);
    _textTitle.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame)+10, 8, self.width*0.6, self.height-10);
}

+ (instancetype)setCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath model:(MineModel *)model
{
    static NSString *ID = @"mineCell";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {cell = [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.leftImage.image = [[UIImage imageNamed:model.icon] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    cell.textTitle.text = model.title;
    cell.accessoryType = model.accessoryType;
    if (model.switchAction) {[cell.contentView addSubview:model.switchAction];}
    return cell;
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
