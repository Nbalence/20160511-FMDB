//
//  EditViewController.m
//  01-FMDBDemo
//
//  Created by qingyun on 16/5/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "EditViewController.h"
#import "DataBaseHandle.h"
#import "QYmode.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfId;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tfId.text=_mode.stu_id;
    _tfName.text=_mode.name;
    _tfAge.text=[NSString stringWithFormat:@"%d",_mode.age];
    // Do any additional setup after loading the view.
}
- (IBAction)editAction:(id)sender {
    //1设置参数
    NSDictionary *paramters=@{@"stu_id":_tfId.text,@"name":_tfName.text,@"age":@(_tfAge.text.intValue)};
    if ([DataBaseHandle UpdateStatmesSql:Update_student_sql WithPrameters:paramters]) {
        NSLog(@"更新成功");
        QYmode *mode=[QYmode new];
        [mode setValuesForKeysWithDictionary:paramters];
        //回调
        self.block(mode);
        //出栈
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
