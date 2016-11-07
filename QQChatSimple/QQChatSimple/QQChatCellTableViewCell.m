//
//  QQChatCellTableViewCell.m
//  QQChatSimple
//
//  Created by MichaelLi on 2016/11/3.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import "QQChatCellTableViewCell.h"
#import "QQChatModel.h"
#import "QQChatFrameModel.h"
@interface QQChatCellTableViewCell ()

@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UIImageView *userImageView;
@property (nonatomic,weak) UIButton *contentButton;
@end
@implementation QQChatCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//重写
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置UI
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UILabel *timeLabel = [[UILabel alloc]init];
    _timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];

    UIImageView *userImageView = [[UIImageView alloc]init];
    _userImageView = userImageView;
    [self.contentView addSubview:userImageView];

    UIButton *contentButton = [[UIButton alloc]init];
    _contentButton = contentButton;
    //设置button上的字体大小
    contentButton.titleLabel.font = [UIFont systemFontOfSize:20];
    contentButton.titleLabel.numberOfLines = 0;

    //设置时间显示问题(时间相同不显示)在这里是拿不到时间数据的
//    if (_timeLabel.text isEqualToString:<#(nonnull NSString *)#>) {
//        <#statements#>
//    }
    //button内容边距
    contentButton.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.contentView addSubview:contentButton];
}

#pragma mark
#pragma mark -  重写Frame
-(void)setQqChatFrameModel:(QQChatFrameModel *)qqChatFrameModel
{
    _qqChatFrameModel = qqChatFrameModel;
    //设置Data
    [self setupData];
    //设置Frame(只是赋值,Frame值在FrameModel中)
    [self setupFrame];
}

-(void)setupData
{
    //数据在Model中
    QQChatModel *qqChatModel = _qqChatFrameModel.qqChatModel;


    //设置时间
    _timeLabel.text = qqChatModel.time;
    //设置时间是否隐藏
    _timeLabel.hidden = qqChatModel.isHiddenTimeLabel;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    //设置内容
    [_contentButton setTitle:qqChatModel.text forState:UIControlStateNormal];
    //    [_contentButton setBackgroundImage:[UIImage imageNamed:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
    [_contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    //    [_contentButton setBackgroundColor:[UIColor orangeColor]];
    //设置头像---判断

    if (qqChatModel.type == QQUserTypeOthers) {

        _userImageView.image = [UIImage imageNamed:@"me"];
//        //取出image
//        UIImageView *imageView = [[UIImageView alloc]init];
//        [imageView setImage:[UIImage imageNamed:@"chat_send_press_pic"]];
//        UIImage *image = imageView.image;
//        //图片拉伸(是以图片的中心点来拉伸)
//        CGFloat resizableImageWidth = image.size.width/2;
//        CGFloat resizableImageHeight = image.size.height/2;
//        [image resizableImageWithCapInsets:UIEdgeInsetsMake(resizableImageHeight, resizableImageWidth, resizableImageHeight, resizableImageWidth) resizingMode:UIImageResizingModeStretch];
        //设置背景图片
        UIImage *image = [self resizableImage:@"chat_send_press_pic"];
        [_contentButton setBackgroundImage:image forState:UIControlStateNormal];
    }else
    {

        _userImageView.image = [UIImage imageNamed:@"other"];
//        //取出image
//        UIImageView *imageView = [[UIImageView alloc]init];
//        [imageView setImage:[UIImage imageNamed:@"chat_recive_press_pic"]];
//        UIImage *image = imageView.image;
//        //图片拉伸(是以图片的中心点来拉伸)
//        CGFloat resizableImageWidth = image.size.width/2;
//        CGFloat resizableImageHeight = image.size.height/2;
//        [image resizableImageWithCapInsets:UIEdgeInsetsMake(resizableImageHeight, resizableImageWidth, resizableImageHeight, resizableImageWidth) resizingMode:UIImageResiz ingModeStretch];
        //取出图片
        UIImage *image = [self resizableImage:@"chat_recive_press_pic"];
        [_contentButton setBackgroundImage:image forState:UIControlStateNormal];
    }


}

#pragma mark
#pragma mark -  抽取拉伸方法
-(UIImage *)resizableImage:(NSString *)imageNamed
{
    //取出image
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:imageNamed]];
    UIImage *image = imageView.image;
    //图片拉伸(是以图片的中心点来拉伸)
    CGFloat resizableImageWidth = image.size.width/2;
    CGFloat resizableImageHeight = image.size.height/2;
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(resizableImageHeight, resizableImageWidth, resizableImageHeight, resizableImageWidth) resizingMode:UIImageResizingModeStretch];
    return image;
}
-(void)setupFrame
{
    _timeLabel.frame = _qqChatFrameModel.timeLabel;
    _contentButton.frame = _qqChatFrameModel.textLabel;
    _userImageView.frame = _qqChatFrameModel.userIcon;
}
@end
