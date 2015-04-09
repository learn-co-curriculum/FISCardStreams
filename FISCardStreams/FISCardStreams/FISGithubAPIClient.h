//
//  FISGithubAPIClient.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Anish

#import <Foundation/Foundation.h>

@interface FISGithubAPIClient : NSObject


/**
 Directs the user to Github login screen and back to FISCardStream://callback
 */
+(void)redirectAfterAuthentication;


/**
 Returns an NSDictionary consisting of the user feed.
 Format:
  {
     "commit_message" = "My commit message";
     "commited_date" = "2015-04-07T21:46:55Z";
     "repo_name" = "MyRepoName";
     username = githubUsername;
  }
 */
+(void)getPublicFeedsWithUsername: (NSString *)username WithCompletionBlock:(void (^)(NSDictionary * feed))completionBlock;



/**
 I don't think we need these -Anish
 */
+(void)getUserRepositoriesWithUsername:(NSString *)Username AndCompletionBlock:(void (^)(NSArray * repos))completionBlock;

+(void)getRepoStatisticsWithRepositoryName:(NSString *)repoistoryName Username: (NSString *)username AndCompletionBlock:(void (^)(NSMutableDictionary * stats))completionBlock;

+(NSString *)convertUnixToTimeStamp:(NSString *)unixTime;


@end
