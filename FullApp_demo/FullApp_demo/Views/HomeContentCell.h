//
//  HomeContentCell.h
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseAPIClient.h"

@interface HomeContentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *type;

-(void)avatarPicForView:(NSString *)url;
-(void)avatarNameAndType:(NSString *)name type:(NSString *)type;
@end
