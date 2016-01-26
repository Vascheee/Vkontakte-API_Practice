//
//  VSLoginVC.m
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSLoginVC.h"
#import "VSAccessToken.h"
#import "MBProgressHUD.h"



@interface VSLoginVC () <UIWebViewDelegate> {
    MBProgressHUD *hud;
}

@property (copy, nonatomic) VSComplitionBlock complitionBlock;
@property (weak, nonatomic) UIWebView *webView;
@end

@implementation VSLoginVC

- (instancetype)initWithComplitionBlock:(VSComplitionBlock)complition;
{
    self = [super init];
    if (self) {
        self.complitionBlock = complition; }
    return self;
}

- (void)dealloc {
    self.webView.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:web];
    web.delegate = self;
    self.webView = web;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                   target:self
                                   action:@selector(dismissController:)];
    (self.navigationItem).rightBarButtonItem = backButton;
    self.navigationController.title = @"Login";
    
    NSString *urlString = @"https://oauth.vk.com/authorize?"
    "client_id=5080520&"
    "display=mobile&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "scope=275436&"
    "response_type=token&"
    "v=5.37";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    hud.dimBackground = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


#pragma mark - Actions
/*=================================================================================================*/


- (void)dismissController:(VSComplitionBlock)block {
    
    if (self.complitionBlock) {
        self.complitionBlock (nil); }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIWebViewDelegate
/*=================================================================================================*/


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
  //  NSLog(@"%@", request.URL.description);
    if ([request.URL.description rangeOfString:@"#access_token="].location != NSNotFound) {
        
        VSAccessToken* token = [[VSAccessToken alloc]init];
        
        NSString* query = request.URL.description;
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if (array.count > 1) {
            query = array.lastObject;
        }
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if (values.count == 2) {
                NSString* key = values.firstObject;
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = values.lastObject;
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [values.lastObject doubleValue];
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    token.userID = values.lastObject;
                }
            }
        }
        self.webView.delegate = nil;
        if (self.complitionBlock) {
            self.complitionBlock(token);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil]; });
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
