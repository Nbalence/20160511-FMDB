//
//  InsertVC.h
//  01-FMDBDemo
//
//  Created by qingyun on 16/5/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYmode.h"


typedef void(^Block)(QYmode *mode);

@interface InsertVC : UIViewController
//回调的block
@property(nonatomic,strong)Block block;

@end
