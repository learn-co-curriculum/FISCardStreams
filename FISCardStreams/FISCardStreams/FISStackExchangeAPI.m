//
//  FISStackExchangeAPI.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISStackExchangeAPI.h"

#import "FISConstants.h"

// Cocoa Pods
#import <AFNetworking.h>
#import <AFOAuth2Manager.h>
#import <AFHTTPRequestSerializer+OAuth2.h>
#import <SSKeychain/SSKeychain.h>

#import "FISStreamsDataManager.h"
#import "FISStream.h"

@implementation FISStackExchangeAPI


+(NSURLRequest *)redirectAfterAuthentication
{
    
    NSString *stackExchangeString = [NSString stringWithFormat:@"https://stackexchange.com/oauth/dialog?client_id=%@&redirect_uri=%@&scope=private_info,no_expiry",STACKEXCHANGE_CLIENT_ID,@"https://stackexchange.com/oauth/login_success"];
    
    NSURL *stackExchangeURL = [NSURL URLWithString:stackExchangeString];
    
    NSURLRequest *stackRequest = [NSURLRequest requestWithURL:stackExchangeURL];
    
    return stackRequest;

}


+ (void)getNetworkActivityForCurrentUserWithCompletionBlock:(void (^)(NSArray *, BOOL))completionBlock
{
    
    NSString *stackExchangeURL = [NSString stringWithFormat:@"%@me/network-activity", STACKEXCHANGE_BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *accessToken = [defaults valueForKey:@"access_token"];
    
    FISStreamsDataManager *streamsDataManager = [FISStreamsDataManager sharedDataManager];
    NSString *stackAccess = [[NSString alloc] init];
    NSString *username = streamsDataManager.userStream.streamName;
    if (username) {
        NSString *accessToken = [SSKeychain passwordForService:SOURCE_STACK_EXCHANGE account:username];
        stackAccess = accessToken;
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *realUSername = [defaults valueForKey:@"fisdev_username"];
        
        NSString *accessToken = [SSKeychain passwordForService:SOURCE_STACK_EXCHANGE account:realUSername];
        stackAccess = accessToken;
    }
    
    if (stackAccess) {
        
        NSDictionary *urlParams = @{@"access_token":stackAccess,
                                    @"key":STACKEXCHANGE_KEY};
        
        
        [manager GET:stackExchangeURL parameters:urlParams success:^(NSURLSessionDataTask *task, id responseObject) {
            
            //NSLog(@"ResponseObject: %@", responseObject);
            NSArray *responseItems = responseObject[@"items"];
            completionBlock(responseItems, YES);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            completionBlock(@[], NO);
            NSLog(@"Failure: %@", error.localizedDescription);
        }];
    } else {
        completionBlock(@[], NO);
        NSLog(@"Stack Exchange access_token not retrieved");
    }
}

@end
