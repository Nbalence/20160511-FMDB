//
//  DataBaseConfigFile.h
//  01-FMDBDemo
//
//  Created by qingyun on 16/5/11.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

//数据库文件名称
#define DBFile @"QYSTUDENT.db"

//sql语句
#define CREATETABLE @"create table if not exists student(stu_id text primary key,name text,age integer);""create table if not exists teacher(stu_id text primary key,name text,age integer);"


//插入语句
#define Insert_student_Sql @"insert into student values(:stu_id,:name,:age)"
//更新
#define Update_student_sql @"update student set name=:name,age=:age where stu_id=:stu_id"
//删除
#define Delete_student_sql @"delete from student where stu_id=:stu_id"
#define Delete_student_sql_all @"delete from student"


//查询本地是否有数据
#define selectSql @"select * from student"
//查询之模糊查询 Name
#define selectLikeSql @"select * from student where name like '%%%@%%'"
