//
//  HomeViewTableCell.h
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *count_t;
@property (strong, nonatomic) IBOutlet UILabel *start_t;
@property (strong, nonatomic) IBOutlet UILabel *total_t;

-(void)initLabel:(NSString *)count start:(NSString *)start total:(NSString *)total;
@end
