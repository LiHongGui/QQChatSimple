//
//  QQChatFrameModel.m
//  QQChatSimple
//
//  Created by MichaelLi on 2016/11/3.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import "QQChatFrameModel.h"
#import "QQChatModel.h"

#define kScreen [UIScreen mainScreen].bounds.size
@implementation QQChatFrameModel


-(void)setQqChatModel:(QQChatModel *)qqChatModel
{
    _qqChatModel = qqChatModel;

    /*
     设置frame
     */
    //时间
    CGFloat margin = 10;
    CGFloat userIconWidth = margin *3;
    CGFloat timeLabelX = 0;
    CGFloat timeLabelY = 0;
    CGFloat timelabelWidth = kScreen.width;
    CGFloat timeLabelHeight = 20;
    _timeLabel = CGRectMake(timeLabelX, timeLabelY, timelabelWidth, timeLabelHeight);

    //文本
    CGFloat textLabelRightX = 2*margin + userIconWidth;
    //文本最大的宽度
    CGFloat textLabelWidth = kScreen.width - 4*margin - 2*userIconWidth;
    //文本最大的size
    CGSize textLabelSize = CGSizeMake(textLabelWidth, MAXFLOAT);
    //文本真实的size
   CGSize textLabelRealSize =  [qqChatModel.text boundingRectWithSize:textLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;

    CGFloat textLabelLeftX = kScreen.width - userIconWidth -2*margin - textLabelRealSize.width  - 4*margin;
    CGFloat textLabelY = CGRectGetMinX(_userIcon) + userIconWidth/2;
    if (qqChatModel.type == QQUserTypeMe) {
        _textLabel = CGRectMake(textLabelRightX, textLabelY,textLabelRealSize.width , textLabelRealSize.height);
    }else {
         _textLabel = CGRectMake(textLabelLeftX, textLabelY,textLabelRealSize.width , textLabelRealSize.height);
    }
    //头像
    CGFloat userIconY = CGRectGetMaxY(_timeLabel) + margin;


    if (qqChatModel.type == QQUserTypeMe) {

        _userIcon = CGRectMake(margin, userIconY, userIconWidth, userIconWidth);
    }else {
        _userIcon = CGRectMake([UIScreen mainScreen].bounds.size.width - margin - userIconWidth, userIconY, userIconWidth, userIconWidth);
    }

    //增加文本的宽高
    _textLabel.size.width += 40;
    _textLabel.size.height += 40;

    //cell

    _cellHeight = CGRectGetMaxY(_textLabel) + margin + timeLabelHeight;
}
@end
