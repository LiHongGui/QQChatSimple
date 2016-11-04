//
//  QQChatModel.m
//  QQChatSimple
//
//  Created by MichaelLi on 2016/11/3.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import "QQChatModel.h"

@implementation QQChatModel


-(instancetype)initWithDcit:(NSDictionary *)dict
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)qqChatModelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDcit:dict];
}
@end
