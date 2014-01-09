//
//  HomeContentCell.m
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import "HomeContentCell.h"

@implementation HomeContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)avatarPicForView:(NSString *)url
{
    //_avatar = [[UIImageView alloc]init];
   // _avatar.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 70, 68);
    [_avatar setClipsToBounds:YES];
    [_avatar setContentMode:UIViewContentModeScaleToFill];
    //self.head1_imageView.image = [UIImage imageNamed:@"u13_normal.png"];
    [_avatar setImageWithURL:[NSURL URLWithString:url]];
    //_avatar.center = CGPointMake(35, 34);
    [self addSubview:_avatar];
}
-(void)avatarNameAndType:(NSString *)name type:(NSString *)type
{
    _name.text = name;
    _type.text = type;
}

@end
