//
//  QQChatModel.h
//  QQChatSimple
//
//  Created by MichaelLi on 2016/11/3.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import <Foundation/Foundation.h>

//枚举
typedef NS_ENUM(NSInteger, QQUserType) {
    QQUserTypeMe,
    QQUserTypeOthers
};
@interface QQChatModel : NSObject
@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,assign) QQUserType type;
//定义属性是否隐藏时间
@property(nonatomic,assign,getter=isHiddenTimeLabel) BOOL hiddenTimeLabel;
-(instancetype)initWithDcit:(NSDictionary *)dict;
+(instancetype)qqChatModelWithDict:(NSDictionary *)dict;

@end
