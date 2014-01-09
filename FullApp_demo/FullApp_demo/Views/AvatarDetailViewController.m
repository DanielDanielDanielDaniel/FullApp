//
//  AvatarDetailViewController.m
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import "AvatarDetailViewController.h"

@interface AvatarDetailViewController ()

@end

@implementation AvatarDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"start");
        self.avatarWebview.delegate = self;
        self.avatarWebview.backgroundColor = [UIColor clearColor];
        [self loadPage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.avatarWebview.delegate = self;
    self.avatarWebview.backgroundColor = [UIColor clearColor];
    [self loadPage];
}
#pragma mark --webView
- (void)loadPage {
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.douban.com/people/Tina-dong/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.avatarWebview loadRequest:request];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
//    [self.view addSubview:self.HUD];
//    self.HUD.mode = MBProgressHUDModeIndeterminate;
//    self.HUD.labelText = CustomLocalizedString(@"正在载入...",@"");
//    [self.HUD show:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"请求结束");
//    [self.HUD hide:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络有误" message:@"请查看网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
