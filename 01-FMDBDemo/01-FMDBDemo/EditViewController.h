//
//  EditViewController.h
//  01-FMDBDemo
//
//  Created by qingyun on 16/5/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYmode.h"

typedef void (^Block)(QYmode *mode);

@interface EditViewController : UIViewController
@property(nonatomic,strong)QYmode *mode;
@property(nonatomic,strong)Block block;
@end
