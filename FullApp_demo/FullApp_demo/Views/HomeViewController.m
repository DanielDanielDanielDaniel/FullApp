//
//  HomeViewController.m
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewTableCell.h"
#import "HomeContentCell.h"
#import "DoubanService.h"
#import "FMDatabase.h"
#import "AvatarDetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
        _homeTable.backgroundColor = nil;
        self.homeTable.delegate = self;
        self.homeTable.dataSource = self;
        [self.view addSubview:self.homeTable];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"FMDB initialize");
    [self initFMDB];
    NSLog(@"Service here");
    DoubanService *service = [[DoubanService alloc]init];
    [service demoRequest:^(NSString *sucess){
        if([sucess isEqualToString:@"sucess"])
        {
           _dataItem = [DoubanModel shareDoubanService];
            NSLog(@"dataItem:%@",_dataItem);
            [_homeTable reloadData];
        }

    } failure:^(NSString *error){
        NSLog(@"%@",error);
    }];
}
-(void)initFMDB
{
    NSString *paths =[ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [paths stringByAppendingPathComponent:@"TestFor-FullApp.db"];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open])
    {
        NSLog(@"Could not open db.");
    }
    [db executeUpdate:@"CREATE TABLE User (Name text,Age integer)"];
//        [db executeUpdate:@"INSERT INTO User (Name,Age) VALUES (?,?)",@"张三",[NSNumber numberWithInt:20]];
    [db executeUpdate:@"UPDATE User SET Name = ? WHERE Name = ? ",@"李四",@"张三"];
    FMResultSet *rs=[db executeQuery:@"SELECT * FROM User"];
    rs=[db executeQuery:@"SELECT * FROM User WHERE Age = ?",@"20"];
    while ([rs next])
    {
        NSLog(@"%@ %@",[rs stringForColumn:@"Name"],[rs stringForColumn:@"Age"]);
    }
}
#pragma mark --tableView
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"豆瓣天堂";
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 70.0f;
    }else{
        return 75.0f;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataItem  users] count]+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        HomeViewTableCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeViewTableCell" owner:self options:nil]objectAtIndex:0];
        [cell initLabel:[NSString stringWithFormat:@"%@",_dataItem.count] start:[NSString stringWithFormat:@"%@",_dataItem.start] total:[NSString stringWithFormat:@"%@",_dataItem.total]];
        return cell;
    }else
    {
        HomeContentCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeContentCell" owner:self options:nil]objectAtIndex:0];
        [cell avatarPicForView:[[_dataItem.users objectAtIndex:indexPath.row-1]objectForKey:@"avatar"]];
        [cell avatarNameAndType:[[_dataItem.users objectAtIndex:indexPath.row-1]objectForKey:@"name"] type:[[_dataItem.users objectAtIndex:indexPath.row-1]objectForKey:@"type"]];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc=[[AvatarDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
