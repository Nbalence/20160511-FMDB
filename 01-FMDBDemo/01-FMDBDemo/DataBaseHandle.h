//
//  DataBaseHandle.h
//  01-FMDBDemo
//
//  Created by qingyun on 16/5/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseConfigFile.h"


@interface DataBaseHandle : NSObject
/**
 * 更新操作
 * @param sql sql语句 UPdate，insert ，delete
 * @param parmater 字典类型的参数 option
 *
 **/
+(BOOL)UpdateStatmesSql:(NSString *)sql WithPrameters:(NSDictionary *)parmater;

/**
 * 查询操作
 * @param sql sql语句 select
 * @param parmater 字典类型的参数 option
 * @param modeName 模型的名称，可以为nil 转换成字典
 *
 **/
+(NSMutableArray *)selectStatmesSql:(NSString *)sql withPrameters:(NSDictionary *)parmters forMode:(NSString *)modeName;




@end
