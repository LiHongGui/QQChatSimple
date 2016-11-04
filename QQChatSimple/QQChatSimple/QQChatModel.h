//
//  QQChatModel.h
//  QQChatSimple
//
//  Created by MichaelLi on 2016/11/3.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQChatModel : NSObject

@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,assign) NSInteger type;
//定义属性是否隐藏时间
@property(nonatomic,assign,getter=isHiddenTimeLabel) BOOL isHiddenTime;
-(instancetype)initWithDcit:(NSDictionary *)dict;
+(instancetype)qqChatModelWithDict:(NSDictionary *)dict;

@end
