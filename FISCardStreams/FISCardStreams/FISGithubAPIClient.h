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

+(void)redirectAfterAuthentication;

+(void)getUserRepositoriesWithUsername:(NSString *)Username AndCompletionBlock:(void (^)(NSArray * repos))completionBlock;


+(void)getRepoStats:(NSString *)repoFullName completionBlock:(void (^)(NSMutableDictionary * stats))completionBlock;

+(NSString *)convertUnixToTimeStamp:(NSString *)unixTime;
@end
