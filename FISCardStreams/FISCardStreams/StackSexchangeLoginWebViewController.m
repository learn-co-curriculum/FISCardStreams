//
//  StackSexchangeLoginWebViewController.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "StackSexchangeLoginWebViewController.h"
#import "FISConstants.h"
#import "FISStackExchangeAPI.h"
#import <AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.h>
#import <AFOAuth2Manager.h>

@interface StackSexchangeLoginWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *stackExchange;
@end

@implementation StackSexchangeLoginWebViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stackExchange.delegate = self;
    
    [self.stackExchange loadRequest:[FISStackExchangeAPI redirectAfterAuthentication]];
    
}


#pragma mark - UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView.request.URL.absoluteString containsString:@"access_token"])
    {
        
        NSString *accessTokenWithExpiry = [webView.request.URL.absoluteString componentsSeparatedByString:@"#"][1];
        // NSString *accessTokenWithAccessToken = [accessTokenWithExpiry componentsSeparatedByString:@"&"][0];
        NSString *realAccessToken = [accessTokenWithExpiry componentsSeparatedByString:@"="][1];
        NSLog(@"Access Token is %@", realAccessToken);
        
        [self storingAccessTokenAsUserDefaults:realAccessToken];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - UIWebViewDelegate Helper Methods

- (void)storingAccessTokenAsUserDefaults:(NSString *)accessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:accessToken forKey:@"access_token"];
    [defaults synchronize];
}


@end
