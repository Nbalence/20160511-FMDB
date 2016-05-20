//
//  DataBaseHandle.m
//  01-FMDBDemo
//
//  Created by qingyun on 16/5/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "DataBaseHandle.h"
#import "FMDB.h"

static FMDatabase *dataBase=nil;

@implementation DataBaseHandle


//获取数据库对象
+(FMDatabase *)getFMDataBase{

    if (dataBase==nil) {
        //初始化
        NSString *docPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        //合并路径
        NSString *dbPath=[docPath stringByAppendingPathComponent:DBFile];
        dataBase=[FMDatabase databaseWithPath:dbPath];
        if ([dataBase open]) {
            //1.创建表
            if (![DataBaseHandle createTable]) {
                NSLog(@"========%@",[dataBase lastErrorMessage]);
            }
        }else {
            NSLog(@"失败");
        }
    }

    return dataBase;
}

+(BOOL)createTable{
//执行多条语句
    return [[DataBaseHandle getFMDataBase] executeStatements:CREATETABLE];
}


+(BOOL)UpdateStatmesSql:(NSString *)sql WithPrameters:(NSDictionary *)parmater{
    if (!parmater) {
        //不带参数的操作
     return  [[DataBaseHandle getFMDataBase] executeUpdate:sql];
    }
       //带参数
    return [[DataBaseHandle getFMDataBase]executeUpdate:sql withParameterDictionary:parmater];
    
}

+(NSMutableArray *)selectStatmesSql:(NSString *)sql withPrameters:(NSDictionary *)parmters forMode:(NSString *)modeName{
   //判断是否带参数
    
    FMResultSet *set;
    if(parmters){
        set=[[DataBaseHandle getFMDataBase] executeQuery:sql withParameterDictionary:parmters];
    }else{
        set=[[DataBaseHandle getFMDataBase] executeQuery:sql];
    }
    //声明一个数组
    NSMutableArray *dataArr=[NSMutableArray array];
    while ([set next]) {
        if (modeName) {
         //字典转模型
            NSObject *class=[NSClassFromString(modeName) new];
            [class setValuesForKeysWithDictionary:[set resultDictionary]];
            
            [dataArr addObject:class];
        }else{
            [dataArr addObject:[set resultDictionary]];
        }
    }
    return dataArr;
}




@end
