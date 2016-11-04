//
//  QQChatFrameModel.h
//  QQChatSimple
//
//  Created by MichaelLi on 2016/11/3.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class QQChatModel;
@interface QQChatFrameModel : NSObject
@property(nonatomic,assign) CGRect textLabel;
@property(nonatomic,assign) CGRect timeLabel;
@property(nonatomic,assign) CGRect typeNumber;
@property(nonatomic,assign) CGRect userIcon;
//cell的高度
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong) QQChatModel *qqChatModel;

@end
