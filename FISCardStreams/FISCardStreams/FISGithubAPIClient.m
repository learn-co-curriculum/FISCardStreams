//
//  FISGithubAPIClient.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Anish

#import "FISGithubAPIClient.h"
#import "FISConstants.h"
#import <AFNetworking.h>
#import <AFOAuth2Manager.h>
#import <AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.h>

@interface FISGithubAPIClient ()

@property (strong, nonatomic) NSMutableArray *retrievedRepos;

@end

@implementation FISGithubAPIClient

+(void)redirectAfterAuth
{
    NSString *githubString = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=repo",GITHUB_CLIENT_ID,@"githubLogin://callback"];
    
    NSURL *githubURL = [NSURL URLWithString:githubString];
    
    [[UIApplication sharedApplication] openURL:githubURL];
}

//gets all of the user's repos and returns an array
+(void)getUserRepos:(NSString *)userName completionBlock:(void (^)(NSArray *))completionBlock
{
    
    NSString *githubURL = [NSString stringWithFormat:@"%@/users/%@/repos??client_id=%@&client_secret=%@", GITHUB_API_URL, userName,GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc]init];
    
    AFOAuthCredential *credential =[AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];
    
    [serializer setAuthorizationHeaderFieldWithCredential:credential];
    
    manager.requestSerializer = serializer;
    
    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * userRepoList = responseObject;
        NSMutableArray * list = [[NSMutableArray alloc]init];
        for (NSDictionary * data in userRepoList) {
            [list addObject:data[@"full_name"]];
        }
        completionBlock(list);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
    
}

//takes a repo name (fullname) and spits out a dictionary of stats {(week id) : (number of commits per week)}
+(void)getRepoStats:(NSString *)repoFullName completionBlock:(void (^)(NSMutableDictionary *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/repos/%@/stats/commit_activity?client_id=%@&client_secret=%@", GITHUB_API_URL, repoFullName, GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc]init];
    
    AFOAuthCredential *credential =[AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];
    
    [serializer setAuthorizationHeaderFieldWithCredential:credential];
    
    manager.requestSerializer = serializer;
    
    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * userRepoList = responseObject;
        NSMutableDictionary *commitStats = [[NSMutableDictionary alloc]init];
        for (NSDictionary * data in userRepoList) {
            NSString * convertDate = [FISGithubAPIClient convertUnixToTimeStamp:data[@"week"]];
            [commitStats setObject:data[@"total"] forKey:convertDate];
        }
        completionBlock(commitStats);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
    
}

+(NSString *)convertUnixToTimeStamp:(NSString *)unixTime
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:[unixTime doubleValue]];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:myDate];
    return formattedDateString;
    
}



@end
