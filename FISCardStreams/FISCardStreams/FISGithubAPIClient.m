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

@interface FISGithubAPIClient ()

@property (strong, nonatomic) NSMutableArray *retrievedRepos;

@end

@implementation FISGithubAPIClient

//gets all of the user's repos and returns an array
+(void)getUserRepos:(NSString *)userName completionBlock:(void (^)(NSArray *))completionBlock
{
    
    NSString *githubURL = [NSString stringWithFormat:@"%@/users/%@/repos?", GITHUB_API_URL, userName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
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
    NSString *githubURL = [NSString stringWithFormat:@"%@//repos/%@/stats/commit_activity?", GITHUB_API_URL, repoFullName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * userRepoList = responseObject;
        NSMutableDictionary *commitStats = [[NSMutableDictionary alloc]init];
        for (NSDictionary * data in userRepoList) {
            [commitStats setObject:data[@"total"] forKey:data[@"week"]];
        }
        completionBlock(commitStats);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
    
}



@end
