//
//  InsertVC.m
//  01-FMDBDemo
//
//  Created by qingyun on 16/5/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "InsertVC.h"
#import "DataBaseHandle.h"
@interface InsertVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfId;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;

@end

@implementation InsertVC

- (IBAction)insertAction:(id)sender {
    
    //1设置参数
    NSDictionary *paramters=@{@"stu_id":_tfId.text,@"name":_tfName.text,@"age":@(_tfAge.text.intValue)};
    //2.执行插入操作
    if ([DataBaseHandle UpdateStatmesSql:Insert_student_Sql WithPrameters:paramters]) {
        NSLog(@"=======插入成功");
        //给mode赋值
        QYmode *mode=[QYmode new];
        [mode setValuesForKeysWithDictionary:paramters];
        self.block(mode);
        //出栈操作
        [self.navigationController popViewControllerAnimated:YES];
        
    }

    
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

@end
