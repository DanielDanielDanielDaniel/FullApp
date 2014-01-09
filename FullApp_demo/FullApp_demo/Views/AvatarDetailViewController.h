//
//  AvatarDetailViewController.h
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarDetailViewController : UIViewController
<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *avatarWebview;

@end
