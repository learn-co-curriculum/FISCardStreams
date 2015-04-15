//
//  FISAppDelegate.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  do not modify

#import "FISAppDelegate.h"
#import "FISGithubAPIClient.h"
#import "FISStreamsDataManager.h"
#import "FISCollectionDataManager.h"
#import "FISCardstreamLogInViewController.h"
#import "FISRSSFeedAPIClient.h"
#import "FISConstants.h"
#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>
#import <AFOAuth2Manager.h>
#import "FISStackExchangeAPI.h"

@interface FISAppDelegate ()

@end

@implementation FISAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
    
    
    //if (self.streamsDataManager.userStream) {
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"LoginFlow" bundle:nil];
    FISCardstreamLogInViewController *loginViewController = [myStoryboard instantiateInitialViewController];
    self.window.rootViewController = loginViewController;
    // }
  
        
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self.streamsDataManager saveContext];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
        
        NSDictionary *urlParams = [url uq_queryDictionary];
        
        NSLog(@"code: %@",urlParams[@"code"]);
        
        NSURL *baseURL = [NSURL URLWithString:@"https://github.com/login/"];
        
        AFOAuth2Manager *manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL
                                                                   clientID:GITHUB_CLIENT_ID
                                                                     secret:GITHUB_CLIENT_SECRET];
        
        manager.useHTTPBasicAuthentication = NO;
        [manager authenticateUsingOAuthWithURLString:@"oauth/access_token"
                                                code:urlParams[@"code"]
                                         redirectURI:@"FISCardStreams://callback"
                                             success:^(AFOAuthCredential *credential)
         {
             
             [AFOAuthCredential storeCredential:credential
                                 withIdentifier:@"githubToken"];
             NSLog(@"store the auth data. Token: %@", credential.accessToken);
             
         } failure:^(NSError *error) {
         }];
    
    return YES;
}

@end
