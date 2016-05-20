//
//  ViewController.m
//  01-FMDBDemo
//
//  Created by qingyun on 16/5/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "QYmode.h"
#import "DataBaseHandle.h"
#import "EditViewController.h"
#import "InsertVC.h"
#define Kurl @"http://afnetworking.sinaapp.com/persons.json"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong) UIRefreshControl *refresh;
@end

@implementation ViewController

-(void)refreshData:(UIRefreshControl*)controller{
    //执行下拉刷新
    [self requestNetwork];
    
}

#pragma mark requestNetworking
-(void)requestNetwork{
   //获取manager对象
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSDictionary *parmaters=@{@"person_type":@"student"};
  //post请求
   [manager POST:Kurl parameters:parmaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
       NSLog(@"=====%@",responseObject);
       //1取出值
       NSArray *tempArr=responseObject[@"data"];
       if (!_dataArr) {
           _dataArr=[NSMutableArray array];
       }else{
       //清空_dataArr的数据
           [_dataArr removeAllObjects];
       //清空数据库的数据
           if ([DataBaseHandle UpdateStatmesSql:Delete_student_sql_all WithPrameters:nil]) {
               NSLog(@"========删除成功");
           };
       //停止刷新
           [_refresh endRefreshing];
       }
       //2.字典转换成模型
       for (NSDictionary *dic in tempArr) {
           //持久化插入到数据库
           if ([DataBaseHandle UpdateStatmesSql:Insert_student_Sql WithPrameters:dic]) {
               NSLog(@"插入数据成功");
           }
           QYmode *mode=[[QYmode alloc] init];
           [mode setValuesForKeysWithDictionary:dic];
           [_dataArr addObject:mode];
       }
       //3.刷新ui
       [self.tableView reloadData];
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"=====%@",error);
   }];
}


#pragma mark searchBar Delegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"======%@====%@",searchBar.text,searchText);
    if (searchText.length>0) {
    _dataArr=[DataBaseHandle selectStatmesSql:[NSString stringWithFormat:selectLikeSql,searchText] withPrameters:nil forMode:@"QYmode"];
    }else{
    //查询所有
    _dataArr=[DataBaseHandle selectStatmesSql:selectSql withPrameters:nil forMode:@
              "QYmode"];
    }
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   //添加searchBar到tableview的头
    UISearchBar *bar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //设置显示取消按钮
    bar.delegate=self;
    //bar.showsCancelButton=YES;
    self.tableView.tableHeaderView=bar;
    
   //2.添加下拉刷新控件
   _refresh=[[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refresh];
    
    
    
    //3.取值网络或者本地取
      //判断数据库里是否有数据
    
    _dataArr=[DataBaseHandle selectStatmesSql:selectSql withPrameters:nil forMode:@"QYmode"];
    if (_dataArr.count>0) {
        [self.tableView reloadData];
    }else{
    [self requestNetwork];
    }
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *indentFier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentFier];
    if ( cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentFier];
    }
    
    QYmode *mode=_dataArr[indexPath.row];
    cell.textLabel.text=mode.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"stu_id:%@        age:%d",mode.stu_id,mode.age];
    
    return cell;

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
      //进行删除操作
        QYmode *mode=_dataArr[indexPath.row];
        NSDictionary *parmaters=@{@"stu_id":mode.stu_id};
        if ([DataBaseHandle UpdateStatmesSql:Delete_student_sql WithPrameters:parmaters]) {
           //执行成功
            for (QYmode *tep in _dataArr) {
            //判断
                if([tep.stu_id isEqualToString:mode.stu_id]){
                 //删除操作
                    [_dataArr removeObject:tep];
                    break;
                }
            }
           //删除界面
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    EditViewController *controller=[self.storyboard instantiateViewControllerWithIdentifier:@"editInderfier"];
    QYmode *mode=_dataArr[indexPath.row];
    controller.mode=mode;

    controller.block=^(QYmode *mode){
     //替换数组的旧值
        NSInteger index=0;
        for (QYmode *tmp in _dataArr) {
            if ([tmp.stu_id isEqualToString:mode.stu_id]) {
                //把数组的值替换掉
                [_dataArr replaceObjectAtIndex:index withObject:mode];
                 break;
            }
            index++;
        }
      //刷新UI
        [tableView reloadData];
        
    };
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark 回调函数
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        InsertVC *insertVc=segue.destinationViewController;
        insertVc.block=^(QYmode *mode){
          //1.当前模型添加到数组
            [_dataArr addObject:mode];
           //2刷新UI
            [self.tableView reloadData];
        };
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
