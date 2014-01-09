//
//  HomeViewController.h
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanModel.h"

@interface HomeViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)UITableView *homeTable;
@property (strong,nonatomic)DoubanModel *dataItem;

@end
